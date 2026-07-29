# Users, groups, privileges and authentication

Sources: Setup Guide user-management and advanced-user-management sections. [S6] [S24]

## Entity types

| Entity | Meaning |
|---|---|
| User | A person who can sign in. Every user must have an account at login.genetec.com; if they do not, they are prompted to create one when added |
| Group | A set of users sharing properties and privileges. A user may belong to several groups. A group can mix administrators and operators |
| Cardholder | A person who badges through doors with credentials. Activities are tracked. Not a sign-in account |

Two attribute families constrain a person:

- **Privileges** - which *activities* they may perform. Determined by their role, and adjustable.
- **Access rights for partitions** - which *entities* they may exercise those privileges on.

## Roles

| Role | Intent |
|---|---|
| Owner | System owners. Grants user-management privileges and the ability to accept terms and conditions. **Only an Owner can grant or remove Owner.** |
| Administrator | Full access to all tasks |
| Operator | Security operators monitoring real-time events. All tasks except Configuration |
| Front desk | Reception staff managing visitors. Basic access-control privileges |

Administrator, Operator and Front desk also exist as **role-based groups** created during installation. Those system groups cannot be deleted or renamed.

## Adding and removing users

1. **Configuration > Users > Add user**, fill in details, pick one or more roles.
2. Leave **Send a welcome email to the user** checked, or clear it and send later from **Users > Status filter = Pending > select user > Send welcome email**.
3. Users stay in **Pending** until they sign in. They activate by clicking the welcome-email link or signing in to the portal directly.

**Critical gotcha:** if the system administrator has not yet signed in and accepted the Terms of Service, newly added users cannot access the system at all.

Deleting a profile (Users > Users tab > select > ... > Delete, then confirm) signs the user out immediately and blocks future sign-ins. It does **not** delete their login.genetec.com account.

## Groups

Create under **Configuration > Users > Groups tab > Add group**, assign one or more roles, save. Then **Groups > select group > Users > Manage users** to add members. Members inherit everything from the group.

## Self-service credential changes

Both password and MFA changes are performed **by the user themselves** at https://login.genetec.com/profile, on the *Security & Confidentiality* page.

- **Change password** - only applies to Genetec-managed accounts. With corporate SSO, the password lives with the identity provider.
- **Change MFA method** - Email (codes by email) or SMS (codes by text; requires a phone number).

**MFA quirk:** even when SMS is selected, Genetec still periodically emails a code to confirm the enrolment email is still valid - for example to catch accounts whose owner has left the company. This applies to Genetec-managed sign-ins across Clearance, ClearID, Cloudrunner, Developer Hub, Genetec Portal, Operations Center and Security Center SaaS. The documented alternative is corporate SSO, which hands identity lifecycle, MFA policy and password complexity to the customer's IT department. [S26]

Sign-in also triggers an email verification code the first time a user signs in, or if they have not signed in for **six months**.

## Advanced user settings (Genetec Configuration desktop only)

Path: **User management > Advanced**, select a user or group.

| Setting | Tab | Notes |
|---|---|---|
| User level | Properties | Priority for PTZ control. **1 is highest.** Ties go to whoever requested the stream first; gaining control locks the camera. Can be overridden per area via *Configure user-level overrides* |
| Access rights | Access rights | Tick partitions. Selecting a partition automatically grants its children; you can then clear individual children |
| Privileges | Privileges | Allow / Deny / Undefined. Undefined inherits from the parent group; with no parent group it means denied. Per-partition **Exceptions** override the base privileges |
| Logon schedule, concurrent-logon limit, auto-disconnect | Advanced | Schedules run on **server time, which is UTC**, not the workstation's. Concurrent-logon limits and auto-disconnect are **not supported by the web and mobile apps** |
| Active tasks and hot actions | Advanced > Operation settings | Also *Start task cycling on logon* |
| Limit archive viewing | Advanced > Security | Set to **Override**, enable, enter the period beyond which archives are hidden |
| Video watermarking | Advanced | Set to **Override**, enable, Configure. Details: Username / Workstation / Camera name (at least one). Type: Single or Mosaic. Position (Single only), Orientation Horizontal or Diagonal (Mosaic only), Opacity (100% = opaque), Size (independent of video resolution). **Cannot be configured on cameras - only on users and groups.** Groups pass it down |
| Default map | Advanced | Map shown when the user opens the Maps task in Genetec Operation |

### Inheritance rules that trip people up

**Access rights:**

- Inherited from parent user groups, and inherited rights **cannot be revoked**.
- Rights not held by a group can still be granted to its members.
- Granting a partition grants its child partitions; revoking a parent revokes children **unless** those children are inherited from a parent group.
- Revoking a child partition does not revoke its parent.

**Privileges:**

- A privilege allowed at group level can be denied at member level.
- Users hold a privilege set per partition they are an authorised user of; partition-level grants and denials replace the base privileges and can differ per partition.
- Best practice stated in the docs: give individual users only the minimum required privileges.

## Third-party authentication and corporate SSO

Security Center SaaS uses an external identity provider **only for authentication**. Authorisation stays internal. [S24]

Supported methods: **Microsoft Entra ID** and **OpenID Connect (OIDC)**.

Setup is **not self-service** - it runs through the Genetec Technical Assistance Center (GTAC):

1. The integrator opens a GTAC case supplying: an email contact for the identity-provider administrator (with rights to create an app integration and grant enterprise-application consent), the identity provider URL (e.g. https://yourtenant.okta.com), and the sign-in domains in use (for myuser@company.com the domain is company.com).
2. Genetec schedules a collaborative call, typically around **15 minutes**, to configure and test.

Once live, the same SSO covers Security Center SaaS, Genetec Airport Badging Solution (ABS), ClearID, Clearance, Cloudrunner, Operations Center and the Genetec Portal (genetec.com).

### One-time transfer for existing users

At their first sign-in after the change, each existing user clicks **Continue** to confirm the new login service, signs in to the corporate IdP, then enters a verification code sent to the email originally used to set their Genetec password, and clicks Continue. The account is then bound to the corporate IdP.

## Automatic user provisioning (SCIM 2.0)

Automates onboarding and offboarding: users added to an Entra ID or Okta group appear in Security Center SaaS; users removed from the IdP are removed from Security Center SaaS. [S24]

**Requirements**

- Security Center SaaS **Premium Plan**, and
- Microsoft Entra ID with at least a **P1** plan, or an Okta **Essential / Professional / Enterprise** licence.

**Limitations**

- **One SCIM connection per system.**
- **Direct group membership only.** No group nesting, no indirect membership, no provisioning of guests or external Entra ID/Okta users.
- Invitation emails are **not** sent to automatically provisioned users.

**Setup** also goes through GTAC. Information to supply: IdP admin contact, sign-in domains, the Security Center SaaS **system name** (visible in user preferences under the user name, or on the *Select a system* page), the **system ID** (e.g. SCC-200012-345678, from the License section of the About page in Genetec Configuration desktop), the Entra ID tenant ID or the Okta tenant URL (found under Okta *Security > API > Issuer Metadata URI*), customer name, and the groups in scope.

**After provisioning - assign roles.** Users with no role, and not in a group with a role, have no access. In **Configuration > Users > Groups**, a yellow dot next to the Groups tab means one or more groups need attention; use **Assign role** in the Roles column. Provisioned groups show `SCIM provisioning` in the Source column.

### Microsoft Entra ID operations

| Task | Where |
|---|---|
| Change which groups sync | Entra ID Overview > Manage > Enterprise applications > (the app created with Genetec) > Manage > Provisioning > Manage > Users and Groups |
| Check sync status | ...> Provisioning > Overview > expand *View provisioning details*. **Completed** shows the last sync; **Provisioning interval** shows the cadence - Entra syncs every **40 minutes** |
| Detailed logs | *View provisioning logs*; use filters if long |
| Force a sync | Entra ID Overview > **Provision on demand** > pick the group > select **up to five users** > Provision |

### Okta operations

| Task | Where |
|---|---|
| Assign groups | Applications > (the app) > Assignments > Assign > Assign to Groups > Assign next to each group, leave fields empty, Save and Go Back, Done |
| Push groups | Push Groups tab > Push Groups > Find groups by name > enter the group name |
| Check sync status | Push groups tab (*Last Push* status), and **View Logs** for the System Log. Use the *Event Info* column; filters, category trends and CSV download are available |
| Force a sync | Push Groups > Pushed Groups > All > select group > Push status column > Active > **Push now**. Or Provisioning tab > Settings > Integration > Attribute Mappings > **Force Sync** for all attributes |

**Okta has no provisioning interval** - updates are pushed as soon as possible.

Okta failures: see the Okta troubleshooting flow in `troubleshooting-and-kbs.md`. [S23]
