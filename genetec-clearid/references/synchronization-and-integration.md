# Getting identity data into ClearID, and integrating with it

Four documented ways to populate and maintain identities, plus custom fields and the public API. [S1]

---

## 1. Choosing a method

| Method | Use it when | Portal home |
|---|---|---|
| **SCIM integration** | The identity source is Microsoft Entra ID, or any IdP that speaks SCIM, and you want the IdP to push changes | Administration > SCIM integration |
| **Local agent / Identity synchronization** | The source is a CSV dropped in a watched folder on-premises | Administration > Identity synchronization |
| **One Identity Synchronization Tool** | The source is Azure AD, a database, or files, and you want a Genetec-supplied on-premises tool to pull and push | Installed on-premises; key issued under Administration > API integrations |
| **ClearID API** | You are writing your own integration, or need functions the UI does not expose | Administration > API integrations |

All four authenticate the same way in the portal: an API key created as an **API integration** at **Administration > API integrations** (route `/administration/service-principals`), except SCIM, which uses its own key generated at **Administration > SCIM integration**. [S2] [S14]

---

## 2. The ClearID API

ClearID is an API-first service: the web interface is built on top of the same public REST API, so most of what the portal can do is reachable through REST endpoints. The API is designed around two goals - platform independence, so any client can call it using standard protocols and negotiated data formats, and independent evolution, so the API can gain functionality without breaking existing clients. It follows REST best practices. [S7]

Practical consequences worth telling a user:

- If they can do it in the portal, assume an endpoint exists and point them at the Genetec developer resources rather than saying it is impossible.
- Version-tolerant clients are expected; an integration should not break when ClearID ships new fields.
- Machine-to-machine access needs an API integration key, not a user account.

Reference topics: "Synchronizing identities using an API in ClearID", "About the ClearID API", "Authenticating your connection with ClearID". [S1]

---

## 3. SCIM integration (Microsoft Entra ID and other IdPs)

SCIM is the cross-vendor standard for provisioning users between an identity provider and a service. In ClearID it lets the IdP create, update and deactivate identities automatically. [S15]

### In ClearID

**Administration > SCIM integration** (`/administration/scim`):

| Control | Purpose |
|---|---|
| Endpoint URL | Two values are shown - one for **Entra ID** and one for **Other identity providers**. Give the IdP the matching one |
| Generate key | Issues the bearer token the IdP will use |
| Active keys | The live keys. This is the answer to "where are the active Entra keys" |
| Force reset and replace | Rotates the key and replaces the existing one |

Also documented: **Resetting SCIM integration identity data in ClearID**, used when the provisioned data set needs to be rebuilt. [S1]

### In Microsoft Azure

Documented sequence: create an enterprise application, connect the ClearID SCIM integration to it, disable the Entra ID **groups** setting, configure Entra ID user settings, configure the synchronization settings, then review the synchronization status in Azure. Attribute mapping is covered by "About Microsoft Entra ID attribute fields in Microsoft Azure". [S1]

Answering pattern: key generation, key rotation and endpoint URLs are ClearID-side; attribute mapping, scoping filters and provisioning schedule are Azure-side. Say which side owns the setting before giving steps.

---

## 4. Local agent identity synchronization (Unified Sync)

**Administration > Identity synchronization** (`/administration/sync`; the tab is internally named "Unified Sync"). A small agent installed on-premises watches a folder for CSV files and feeds ClearID. [S2]

Top level: **Download local agent**, **Add synchronization**, and the list of existing configurations.

Inside a configuration:

| Section | What to check when something is wrong |
|---|---|
| Overview | hostname, agent version, last sync - confirms the agent is alive and which machine it runs on |
| Local agent authentication | the API key binding; the key itself is created under Administration > API integrations |
| Synchronization folder | the watched path; wrong path is the most common "nothing happens" cause |
| CSV template | the expected columns |
| Identity field mappings | CSV column to ClearID identity field |
| Credential field mappings | CSV column to credential field |
| Advanced configurations | Delimiter and Encoding - the usual cause of garbled names or one-column imports |
| Management | activate the configuration, or upload a single CSV for a one-off run or a test |
| Synchronization logs | per-run results and errors |
| Delete synchronization | removes the configuration |

Diagnostic order for "sync is not working": Overview (is the agent reporting?) then Synchronization logs (did a run happen and what failed?) then Synchronization folder and Advanced configurations (is the file being seen and parsed?) then Identity field mappings (is the data landing in the right fields?).

---

## 5. One Identity Synchronization Tool

A separate Genetec on-premises tool for pulling identities from an external source and pushing them to ClearID. Documented lifecycle: install, upgrade, uninstall. It is accompanied by an Azure web app component. [S1]

| Topic area | Notes |
|---|---|
| Data sources | Three documented source types, each with its own configuration topic: **Azure AD**, **Database**, **File** |
| Connection settings | Points the tool at the ClearID tenant; needs TCP 443 outbound to `*.clearid.io` |
| Attribute fields | "About ClearID One Identity Synchronization Tool attribute fields" defines what maps to what |
| Synchronization settings | Controls what is synchronized and how often |
| Status and logs | "Reviewing synchronization status" and "About ClearID One Identity Synchronization Tool logs" / "Viewing the ... logs" |
| Updating existing identities | A dedicated topic covers refreshing identities that already exist in ClearID from the external source |

Two troubleshooting topics exist specifically for this tool - connectivity issues and data synchronization issues. Connectivity is almost always the 443 outbound rule or the credential; data issues are almost always attribute mapping. [S12]

---

## 6. Custom fields

**Administration > Custom fields** (`/administration/custom-fields`) extends the identity schema. [S2]

- **Sections** group fields in the UI. Create one with **Add custom field section**.
- **Add custom field** (`/administration/custom-fields/new-field`) asks for: Display name, Custom field ID, data type, Read-only, Enable synchronization.
- Data types: **Boolean, Date, Date-Time, Decimal, Numeric, Text**.
- **Enable synchronization** is the switch that lets an external source populate the field - relevant to every method in this file.
- **Read-only** stops portal users editing a field that a sync owns.

Two documented companion topics: **Modifying ClearID custom fields in Genetec Configuration desktop** - custom fields can be touched from the Security Center configuration side as well as in ClearID - and **Custom fields relationships**, which covers how the fields relate to each other and to other objects. When someone asks why a custom field will not accept an edit, check Read-only, then Enable synchronization, then whether the field is being driven from the Security Center side. [S1]

---

## 7. Cardholder and credential ownership

Before diagnosing any sync problem, establish which system is the source of truth. **Administration > Systems > [system] > Cardholder and credential management** selects **ClearID** or **Security Center**. That choice decides which side wins when both hold a value, and it explains a lot of "my change did not stick" reports. The same page shows Status, Security Center system ID, Security Center version, Plugin version, Last plugin response and Last plugin query - use those to prove whether the two systems are communicating at all. [S2]

Credential synchronization has its own mode setting and its own log viewer at **Administration > Credentials**. [S2]
