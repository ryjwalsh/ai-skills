# SAFR API and Integration

SAFR exposes four REST services. Everything below is verbatim from the vendor REST API docs.

## Contents

| Section | Topic |
|---|---|
| 1 | The four services and their endpoints |
| 2 | OpenAPI documentation locations |
| 3 | Authentication and required headers |
| 4 | Directories |
| 5 | COVI: identity operations |
| 6 | CVEV: event operations |
| 7 | Event listening (long-poll) pattern |
| 8 | Documentation defects in the API pages |
| 9 | Privacy and log retention |
| 10 | SDKs |
| 11 | Not documented |

## 1. The four services and their endpoints

| Service | Abbrev. | Cloud host | Local HTTPS port | Local HTTP port |
|---|---|---|---|---|
| SAFR Computer Vision API | COVI | `covi.real.com` | `8080` | `8081` |
| SAFR Computer Vision Events Server API | CVEV | `cv-event.real.com` | `8082` | `8083` |
| SAFR VIRGA Server API | VIRGA | `virga.real.com` | `8084` | `8085` |
| SAFR Object Server API | CVOS | `cvos.real.com` | `8086` | `8087` |

This table is the single most useful thing in this file: it reconciles the port numbers that
appear inconsistently elsewhere. The Web Console Status page defaults (`8081` CoVi, `8085`
VIRGA, `8087` CVOS) are all the **HTTP** ports. [S14] [S26]

## 2. OpenAPI documentation locations

OpenAPI documentation is available for SAFR services in the SAFR Cloud via HTTPS. [S26]

| Service | Cloud OpenAPI URL |
|---|---|
| COVI | `https://covi.real.com/docs/index.html` |
| CVEV | `https://cv-event.real.com/docs/index.html` |
| VIRGA | `https://virga.real.com/docs/index.html` |
| CVOS | `https://cvos.real.com/docs/index.html` |

With an **on-premises licence** the API documentation is served locally. Substitute the server's
IP address or DNS name. [S26]

| Service | Local OpenAPI URL |
|---|---|
| COVI | `https://<ipaddress or localhost>:8080/docs/index.html` or `http://<ipaddress or localhost>:8081/docs/index.html` |
| CVEV | `https://<ipaddress or localhost>:8082/cv-event/docs/index.html` or `http://<ipaddress or localhost>:8083/cv-event/docs/index.html` |
| VIRGA | `https://<ipaddress or localhost>:8084/virga/docs/index.html` or `http://<ipaddress or localhost>:8085/virga/docs/index.html` |
| CVOS | `https://<ipaddress or localhost>:8086/cvos/docs/index.html` or `http://<ipaddress or localhost>:8087/cvos/docs/index.html` |

**Point on-prem users here first.** Their own server hosts a live, version-correct OpenAPI spec,
which is more trustworthy than these prose pages.

## 3. Authentication and required headers

Authentication is by a single header carrying account credentials. There is no documented token,
OAuth, or API-key flow. [S27] [S33]

| Header | Purpose |
|---|---|
| `X-RPC-AUTHORIZATION: userid:pwd` | Authentication. Substitute `userid` and `pwd` with credentials issued for your account |
| `X-RPC-DIRECTORY: main` | Identifies the directory used. Required |
| `Content-Type:application/octet-stream` | For image uploads |
| `X-RPC-PERSON-NAME:First Last` | Name to assign on import |
| `X-RPC-EXTERNAL-ID: 0000001` | External identifier to attach to the identity |
| `X-RPC-FACES-GROUPINGTHRESHOLD: 0` | Face grouping threshold override |

The docs state "Always use https when making requests over the internet." [S28] [S34] Because
credentials travel in a plain header on every call, and because the default TLS certificate is a
shared self-signed one [S11], treat plain-HTTP use of these ports as credential exposure.

## 4. Directories

All data in different directories is separate. Use multiple directories when creating multiple
identity sets for completely different uses. **The maximum number of directories supported is 10
per account.** The examples use `main`, which is also the documented default user directory.
[S28] [S14]

## 5. COVI: identity operations

COVI provides the ability to import a face from an image as a new identity, retrieve stored
identities, delete stored identities, retrieve images of stored identities, and match images
against stored identities. [S27]

### 5.1 Import a face as a new identity

Local host [S28]:

```
curl -v -X POST -H "Content-Type:application/octet-stream" -H "X-RPC-DIRECTORY: main" -H "X-RPC-AUTHORIZATION: userid:pwd" -H "XRPC-PERSON-NAME:First Last" -H "X-RPC-EXTERNAL-ID: 0000001" "http://localhost:8080/people?update=false" --data-binary @IMG_0000001.jpg
```

SAFR Cloud [S28]:

```
curl -v -X POST -H "Content-Type:application/octet-stream" -H "X-RPC-DIRECTORY: main" -H "X-RPC-AUTHORIZATION: userid:pwd" -H "XRPC-PERSON-NAME:First Last" -H "X-RPC-EXTERNAL-ID: 0000001" "https://covi.real.com/people?update=false" --data-binary @IMG_0000001.jpg
```

Documented behaviour: the call first attempts to match a face already present in the `main`
directory of the account, and only imports it as a new identity if the face does not match an
existing one, **and only if the new face meets default pose, sharpness, and contrast quality**.
If a match is found, information about the matched identity is returned (`personId`). If a new
identity is formed, the response includes `newId` set to `true`. [S28]

With quality overrides disabled [S28]:

```
curl -v -X POST -H "Content-Type:application/octet-stream" -H "X-RPC-DIRECTORY: main" -H "X-RPC-AUTHORIZATION: userid:pwd" -H "X-RPC-PERSON-NAME:0000001" -H "X-RPC-EXTERNAL-ID: 0000001" -H "X-RPC-FACES-GROUPINGTHRESHOLD: 0" "http://localhost:8080/people?min-cpq=0&min-fsq=0&min-fcq=0&update=false" --data-binary @IMG_0000001.jpg
```

| Query parameter | Meaning |
|---|---|
| `update=false` | Do not update an existing identity |
| `min-cpq` | Minimum center pose quality. `0` disables the check [INFERRED - verify] |
| `min-fsq` | Minimum face sharpness quality. `0` disables the check [INFERRED - verify] |
| `min-fcq` | Minimum face contrast quality. `0` disables the check [INFERRED - verify] |

The expansions of `cpq`, `fsq` and `fcq` are inferred from the prose "pose, sharpness, and
contrast quality" - the docs never spell the abbreviations out. Setting all three to `0` is how
bulk enrolment from imperfect ID photos is done, at the cost of match reliability.

### 5.2 Import response

| Element | Type | Meaning |
|---|---|---|
| `accountUpdated` | Boolean | Whether COVI made changes to the account regarding person, face, or metadata about faces |
| `detectionTime` | Integer | Time to detect a face, in milliseconds |
| `identifiedFaces` | Array | Array of identifiedFaces data |
| `personId` | String | ID of the recognized person |
| `name` | String | Name associated with the recognized person |
| `newId` | Boolean | `true` signifies a new identity |

Sample response shape [S28]:

```
{
"accountUpdated": true,
"detectionTime": 324,
"identifiedFaces": [
{
"personId": "866e75a6-e22a-4077-97bb- e5dbfe1c513e",
"name": "First Last",
"newId": true
}
]
}
```

Note the sample `personId` in the docs contains a stray space (`97bb- e5db`). It is a
typographical error in the documentation, not a format feature. Person IDs are UUIDs.
[INFERRED - verify]

### 5.3 Other COVI operations

| Operation | Resource |
|---|---|
| Retrieve stored identities | `/people` [S29] |
| Delete stored identities | `/people` [S30] |
| Retrieve images of stored identities | documented separately [S31] |
| Match images against stored identities | documented separately [S32] |

Exact verbs, paths and parameters for 5.3 were not captured in full during retrieval - use the
local OpenAPI spec at `/docs/index.html` for authoritative signatures. Logged as a gap.

## 6. CVEV: event operations

CVEV provides the ability to retrieve events stored in the directory, retrieve images associated
with events, and listen for new events and retrieve them as they occur. [S33]

| Goal | Request |
|---|---|
| All events in a directory | `curl -X GET "http://localhost:8082/events?sinceTime=0" -H "X-RPC-AUTHORIZATION: userId:pwd" -H "X-RPC-DIRECTORY: main"` |
| Events currently in progress (not yet ended) | `curl -X GET "http://localhost:8082/events" -H "X-RPC-AUTHORIZATION: userId:pwd" -H "X-RPC-DIRECTORY: main"` |
| Events in the last 60 seconds | `curl -X GET "http://localhost:8082/events?sinceTime=<currentEpochTimeInMs-60000>" ...` |
| Cloud equivalent | `curl -X GET "https://cv-event.real.com/events?sinceTime=0" ...` |

`sinceTime=0` returns all events recorded in a directory. Omitting `sinceTime` returns only
in-progress events. [S34]

## 7. Event listening (long-poll) pattern

This is the documented way to build a live integration. [S36]

Step 1 - block waiting for change:

```
curl -X GET "http://localhost:8082/event/status?since=<currentEpochTimeInMs>" -H "X-RPC-AUTHORIZATION: userId:pwd" -H "X-RPC-DIRECTORY: main"
```

The request **blocks** until a new event is recorded or started, or until an existing event is
updated. Previously recorded but still active events without an end date undergo updates, for
example a person identity being assigned, or an event being given an end time as the face
disappears from view. [S36]

| Response | Action |
|---|---|
| Times out, or HTTP `204` | Submit the request again |
| HTTP `200` | Read `lastModDate` and fetch the changed events |

Step 1 response fields [S36]:

| Element | Type | Meaning |
|---|---|---|
| `lastModDate` | integer | Epoch ms of last inserted or updated event |
| `serverDate` | integer | Epoch ms on the server |
| `since` | integer | Excludes events whose `endDate` is prior to this value |
| `sinceModDate` | integer | Ensures returned events have a `modDate` greater than this value |

Step 2 - fetch what changed:

```
curl -X GET "http://localhost:8082/events?since=0&sinceModDate=<epochTimeInMsUsedInStatusCallAbove>" -H "X-RPC-AUTHORIZATION: userId:pwd" -H "X-RPC-DIRECTORY: main"
```

**Critical detail that breaks most first implementations:** the `since` parameter with a value of
`0` **must** also be included, or only live (in progress) events are returned. [S36]

Step 3 - loop: issue `/event/status` again, using the recorded `lastModDate` as the new `since`
value, and keep alternating retrieval and listening. [S36]

There is **no documented webhook or push mechanism.** Long-polling `/event/status` is the
supported pattern. Rate limits are **Not documented**.

## 8. Documentation defects in the API pages

These matter because copy-pasting the docs verbatim will fail. All logged as gaps.

| Defect | Detail |
|---|---|
| Auth header name inconsistent | The COVI overview page prints `X-RPCAUTHORIZATION` (no hyphen after RPC); every other page prints `X-RPC-AUTHORIZATION`. Use `X-RPC-AUTHORIZATION` [S27] [S33] |
| Person-name header inconsistent | Two examples on the same page print `XRPC-PERSON-NAME` and `X-RPC-PERSON-NAME`. Use `X-RPC-PERSON-NAME` [S28] |
| Scheme/port mismatch, COVI | Examples use `http://localhost:8080`, but the overview lists `8080` as the **HTTPS** port and `8081` as HTTP [S26] [S28] |
| Scheme/port mismatch, CVEV | Examples use `http://localhost:8082`, but the overview lists `8082` as the **HTTPS** port and `8083` as HTTP [S26] [S34] |
| Case inconsistency | `userid:pwd` on COVI pages, `userId:pwd` on CVEV pages |

Guidance: trust the **port table** in section 1 and the local OpenAPI spec over the inline curl
examples, and normalise header names to the hyphenated forms.

## 9. Privacy and log retention

To protect privacy, SAFR limits retention of system logs associated with events to a time frame
configured using an admin system API. When used together with `eventArchiveTimeLimit` in the
Admin Tenant API, no trace of individual whereabouts is kept beyond the configured retention
time. Recognition logs are reduced in their default logging level so as not to include any
personally identifiable information (PII). [S26]

The Admin Tenant API and Admin System API themselves are **not documented** in the retrieved
pages beyond this mention. `eventArchiveTimeLimit` is the only named key. Logged as a gap.

This pairs with the logging defaults in `operations.md`: raising log levels to `DEBUG` or
`TRACE` for diagnosis may reintroduce PII into logs, since `TRACE` in some cases contains the
actual data for requests. [S3] Lower levels again after diagnosis.

## 10. SDKs

| SDK | Version noted | Source |
|---|---|---|
| SAFR SDK | `2.1.27`, released April 6 2020 | [S38] |
| SAFR Embedded SDK (eSDK), armeabi-v7a | `3.12.2` | [S38] |
| SAFR Embedded SDK (eSDK), arm64-v8a | `3.13.14` | [S38] |

The SDK versions on the developer page are old relative to the current product. Prefer the REST
API for new integrations unless there is an on-device requirement. [INFERRED - verify]

## 11. Not documented

| Item | Status |
|---|---|
| Rate limits | Not documented |
| Webhooks / push events | Not documented; use long-poll `/event/status` |
| API versioning scheme | Not documented |
| Error code catalogue for REST responses | Not documented beyond `200` and `204` semantics on `/event/status` |
| OAuth / token / API-key auth | Not documented; only `X-RPC-AUTHORIZATION: userid:pwd` |
| VIRGA and CVOS resource paths | Not documented in prose; use the local OpenAPI spec |
| Pagination for `/events` and `/people` | Not documented |
