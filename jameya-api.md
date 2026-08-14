# Jameya API — Complete Phase 1 Documentation

> Base URL: `https://jameya-backend.onrender.com`
>
> This document combines the Jameya API details previously discussed with the uploaded Phase 1 API documentation.
>
> **Security note:** The uploaded API documentation contains example JWTs and credentials. They are reproduced only where necessary as documentation examples; do not use them in production. Rotate any real credentials/tokens that were exposed.

## Previously confirmed Circle Creation

### `POST /admin/circles`

Creates a new circle draft. The backend automatically looks up the active fee policy for the requested duration.

**Headers**
```http
Authorization: Bearer <admin_token>
Content-Type: application/json
```

**Request**
```json
{
  "amount": 10000,
  "contributionAmount": 1000,
  "durationMonths": 10,
  "memberCapacity": 10,
  "cycleFrequency": "MONTHLY",
  "startDate": "2026-12-01T00:00:00.000Z"
}
```

**Response — `201 Created`**
```json
{
  "id": "64435e07-a84c-4430-bd89-ef0e0f856a0a",
  "amount": "10000",
  "contributionAmount": "1000",
  "durationMonths": 10,
  "cycleFrequency": "MONTHLY",
  "memberCapacity": 10,
  "currentMembersCount": 0,
  "startDate": "2026-12-01T00:00:00.000Z",
  "endDate": "2027-10-01T00:00:00.000Z",
  "status": "DRAFT"
}
```

The uploaded documentation provides the complete response structure, including `feePolicyId`, `feePolicySnapshot`, `feePolicy`, `memberships`, `circleCode`, `overview`, timestamps, and related fields.

### Known errors discussed previously

- `400 Bad Request` — validation failure, including amount/member-capacity mismatch scenarios.
- `422` — no active fee policy for the requested duration / eligibility-related validation.

---

## API Endpoint Index

The uploaded Phase 1 specification documents the following endpoint groups:

### Authentication
- `POST /auth/request-otp`
- `POST /auth/verify-otp`
- `POST /auth/refresh`
- `POST /auth/logout`

### Admin — Fee Policies
- `POST /admin/fee-policies`
- `GET /admin/fee-policies`
- `POST /admin/fee-policies/{id}/activate`
- `GET /admin/fee-policies/active`
- `GET /admin/fee-policies/{id}`

### Customer — Circles & Home
- `GET /customer/circles`
- `GET /customer/circles/{id}`
- `GET /customer/home`
- `GET /customer/my-circles`
- `POST /customer/circles/{id}/join-intent`
- `GET /customer/circles/{id}/positions`
- `POST /customer/circles/{id}/join`
- `POST /customer/join/{membershipId}/contract/accept`
- `POST /customer/join/{membershipId}/contract/verify-otp`
- `GET /customer/history`

### Customer — Contracts
- `GET /customer/contracts`
- `GET /customer/contracts/{membershipId}`
- `GET /customer/contracts/{membershipId}/download`

### Customer — Payment Methods
- `GET /customer/payment-methods`
- `POST /customer/payment-methods/verify`
- `PATCH /customer/payment-methods/{id}/set-default`
- `DELETE /customer/payment-methods/{id}`

### Payments Webhook
- `POST /payments/webhook/gateway`

### Customer — Notifications
- `GET /customer/notifications`
- `GET /customer/notifications/unread-count`
- `PATCH /customer/notifications/read-all`
- `PATCH /customer/notifications/{id}/read`

### Customer — Profile & Verification
- `GET /customers/profile`
- `POST /customers/profile`
- `POST /customers/documents`
- `POST /customers/kyc/submit`
- `GET /customers/kyc-status`

### Admin — Auth
- `POST /admin/auth/login`
- `POST /admin/auth/refresh`
- `POST /admin/auth/logout`

### Admin — Profile
- `GET /admin/profile`
- `PATCH /admin/profile/password`

### Admin — Dashboard
- `GET /admin/dashboard`

### Admin — User Management
- `GET /admin/users`
- `POST /admin/users`
- `PATCH /admin/users/{id}/status`
- `PATCH /admin/users/{id}/role`

### Admin — Customers
- `GET /admin/customers`
- `GET /admin/customers/{id}`
- `PATCH /admin/customers/{id}/status`

### Admin — Payments
- `GET /admin/payment-proofs`
- `PATCH /admin/payment-proofs/{id}/review`
- `PATCH /admin/payment-proofs/{id}/flag`
- `PATCH /admin/transactions/{id}/hold`

### Admin — Roles
- `GET /admin/roles`

### Admin — Circles
- `POST /admin/circles`

### Complete Endpoint Inventory

> **Total documented endpoints:** 71
> This inventory is derived from the merged Jameya Phase 1 API documentation. Detailed request/response information remains in the endpoint sections below.

#### `/auth`

- `POST /auth/request-otp` — Request an OTP verification code via Email
- `POST /auth/verify-otp` — Verify OTP and authenticate user (returns JWT Access & Refresh tokens)
- `POST /auth/refresh` — Refresh Access Token using Refresh Token Bearer header
- `POST /auth/logout` — Logout and revoke active refresh tokens

#### `/admin`

- `POST /admin/fee-policies` — Create a new draft fee policy (admin only)
- `GET /admin/fee-policies` — List all fee policies with optional status filter
- `POST /admin/fee-policies/{id}/activate` — Activate a draft fee policy (requires audit reason)
- `GET /admin/fee-policies/active` — Get the currently active fee policy for a given duration
- `GET /admin/fee-policies/{id}` — Get a fee policy by ID
- `POST /admin/auth/login` — Admin login with email and password
- `POST /admin/auth/refresh` — Rotate admin refresh token
- `POST /admin/auth/logout` — Revoke all active admin sessions
- `GET /admin/profile` — Get the logged-in admin's own profile
- `PATCH /admin/profile/password` — Change own password (revokes all existing sessions)
- `GET /admin/dashboard` — Get aggregated admin dashboard statistics
- `GET /admin/users` — List all admin accounts
- `POST /admin/users` — Create a new admin account
- `PATCH /admin/users/{id}/status` — Update admin account status (suspend / reactivate) — reason required
- `PATCH /admin/users/{id}/role` — Change the role assigned to an admin — reason required
- `GET /admin/customers` — List customers with pagination and filters
- `GET /admin/customers/{id}` — Get full customer profile including KYC, documents, and memberships
- `PATCH /admin/customers/{id}/status` — Update customer account status — reason required
- `GET /admin/payment-proofs` — List all pending manual payment proof submissions
- `PATCH /admin/payment-proofs/{id}/review` — Approve or reject a payment proof — reason required on REJECTED
- `PATCH /admin/payment-proofs/{id}/flag` — Flag a payment proof for investigation — reason required
- `PATCH /admin/transactions/{id}/hold` — Place a transaction on hold for investigation — reason required
- `GET /admin/roles` — List all available roles — used to populate role picker when creating admins
- `POST /admin/circles` — Create a new circle draft (auto-looks up active fee policy)
- `GET /admin/circles` — List all circles with optional status filter
- `GET /admin/circles/{id}` — Get a single circle by ID (includes memberships)
- `PATCH /admin/circles/{id}` — Edit circle properties — only core property changes past DRAFT require a reason (BR-05)
- `PATCH /admin/circles/{id}/activate` — Activate a DRAFT circle — moves it to UPCOMING and locks fee policy
- `PATCH /admin/circles/{id}/cancel` — Cancel a circle at any stage — reason required (SRS 8.1)
- `GET /admin/installments` — Get installments filterable by status, search, with pagination
- `GET /admin/installments/{id}` — Get late payment installment detail by ID
- `GET /admin/transactions` — Get transactions for payment review with status tabs, search, and pagination
- `GET /admin/payouts` — List payouts with status filter, search, summary header, and pagination
- `PATCH /admin/payouts/{id}/confirm` — Single admin action to confirm and disburse payout (idempotent)
- `GET /admin/kyc/pending-documents` — List all submitted documents awaiting admin review
- `PATCH /admin/kyc/documents/{id}/review` — Approve or reject a submitted customer document
- `POST /admin/kyc/eligibility` — Assign trust score and participation budget/limit to customer

#### `/customer`

- `GET /customer/circles` — Browse open upcoming circles (unfiltered by eligibility)
- `GET /customer/circles/{id}` — Get circle detail with structurally masked member view
- `GET /customer/home` — Customer home dashboard and recommended circles
- `GET /customer/my-circles` — Customer joined circles progress list (تقدم الجمعيات)
- `POST /customer/circles/{id}/join-intent` — Pre-check eligibility and capacity before joining flow
- `GET /customer/circles/{id}/positions` — Near-real-time live position availability and fee preview
- `POST /customer/circles/{id}/join` — ENDPOINT 1: Start join reservation (15-min TTL, draft contract generated)
- `POST /customer/join/{membershipId}/contract/accept` — ENDPOINT 3: Accept contract terms & request signature OTP
- `POST /customer/join/{membershipId}/contract/verify-otp` — ENDPOINT 4: Verify signature OTP & finalize membership
- `GET /customer/history` — Get unified customer dashboard summary & historical activity feed (GET /customer/history)
- `GET /customer/payment-methods` — Get saved payment methods on customer profile
- `POST /customer/payment-methods/verify` — Verify and save a new Visa/Card token to customer profile
- `PATCH /customer/payment-methods/{id}/set-default` — Set default payment method
- `DELETE /customer/payment-methods/{id}` — Remove a payment method from customer profile
- `GET /customer/notifications` — Get customer in-app notifications (paginated, filter by ?unread=true)
- `GET /customer/notifications/unread-count` — Get unread notification count badge counter
- `PATCH /customer/notifications/read-all` — Mark all notifications as read for current customer
- `PATCH /customer/notifications/{id}/read` — Mark a specific notification as read by ID
- `GET /customer/installments` — Get current balance, next due, and full schedule by circle (FR-11)
- `GET /customer/installments/history` — Get unified payment and transaction history timeline (سجل المعاملات)
- `GET /customer/installments/{id}` — Get single installment details, attempt history, and receipt if paid (FR-11)
- `POST /customer/installments/{id}/pay` — Pay due installment immediately via customer linked payment method (ادفع الآن)
- `POST /customer/installments/{id}/submit-proof` — Submit manual payment proof (Vodafone Cash / InstaPay) - Feature Flagged

#### `/payments`

- `POST /payments/webhook/gateway` — Handle Card Gateway Callback Webhook (Idempotent)

#### `/customers`

- `GET /customers/profile` — Get authenticated customer profile (name, email, phone, status)
- `POST /customers/profile` — Submit or update legal identity profile details
- `POST /customers/documents` — Upload verification document (National ID, Income Proof, etc.)
- `POST /customers/kyc/submit` — Submit KYC for admin review
- `GET /customers/kyc-status` — Get aggregated customer KYC status, documents, and eligibility

#### `/storage`

- `POST /storage/upload` — Upload a KYC document file to Cloudinary


---

## Important Business Flow

The customer join flow documented by the API is:

1. Browse available circles.
2. Open circle details.
3. Check eligibility/capacity using `join-intent`.
4. Read available positions and fee previews.
5. Start joining a selected position.
6. Receive a temporary reservation/draft contract.
7. Accept contract terms.
8. Request contract-signature OTP.
9. Verify OTP.
10. Finalize membership.
11. Access signed contracts and customer history.

### Eligibility

The API uses structured eligibility errors such as:

```json
{
  "reason": "eligibility_incomplete",
  "missingSteps": [
    "proof_of_income",
    "eligibility_decision"
  ]
}
```

### Position fee calculation

For a 6-month circle with a gross value of `12000`, the documented example shows:

| Position | Available | Fee % | Fee Amount | Net |
|---:|---|---:|---:|---:|
| 1 | true | 8% | 960.00 | 11040.00 |
| 2 | true | 7% | 840.00 | 11160.00 |
| 3 | true | 4% | 480.00 | 11520.00 |
| 4 | true | 0% | 0.00 | 12000.00 |
| 5 | true | -15% | -1800.00 | 13800.00 |
| 6 | true | -24% | -2880.00 | 14880.00 |



---

# Uploaded Phase 1 API Specification — Full Source

# Jameya API - Phase 1

```
 1.0 
```

```
OAS 3.0
```

Backend REST API for Auth, Admin, and Circle Management

**Authorize**

### [Authentication](https://jameya-backend.onrender.com/api-docs#/Authentication)

**POST**

[**/auth/request-otp**](https://jameya-backend.onrender.com/api-docs#/Authentication/AuthController_requestOtp)

Request an OTP verification code via Email

**POST**

[**/auth/verify-otp**](https://jameya-backend.onrender.com/api-docs#/Authentication/AuthController_verifyOtp)

Verify OTP and authenticate user (returns JWT Access & Refresh tokens)

**POST**

[**/auth/refresh**](https://jameya-backend.onrender.com/api-docs#/Authentication/AuthController_refresh)

Refresh Access Token using Refresh Token Bearer header

**POST**

[**/auth/logout**](https://jameya-backend.onrender.com/api-docs#/Authentication/AuthController_logout)

Logout and revoke active refresh tokens

### [Admin – Fee Policies](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Fee%20Policies)

**POST**

[**/admin/fee-policies**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Fee%20Policies/FeePoliciesController_createDraft)

Create a new draft fee policy (admin only)

**GET**

[**/admin/fee-policies**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Fee%20Policies/FeePoliciesController_findAll)

List all fee policies with optional status filter

**POST**

[**/admin/fee-policies/{id}/activate**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Fee%20Policies/FeePoliciesController_activate)

Activate a draft fee policy (requires audit reason)

**GET**

[**/admin/fee-policies/active**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Fee%20Policies/FeePoliciesController_findActiveByDuration)

Get the currently active fee policy for a given duration

**GET**

[**/admin/fee-policies/{id}**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Fee%20Policies/FeePoliciesController_findOne)

Get a fee policy by ID

### [Customer – Circles & Home Discovery](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery)

**GET**

[**/customer/circles**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_browseCircles)

Browse open upcoming circles (unfiltered by eligibility)

#### Parameters

**Cancel**

No parameters

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/circles' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/circles
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
{
  "data": [
    {
      "id": "a712dc21-4f12-4d49-a114-35e5bf5cf340",
      "title": "جمعية شهر 8",
      "amount": "30000",
      "contributionAmount": "3000",
      "durationMonths": 10,
      "cycleFrequency": "MONTHLY",
      "memberCapacity": 10,
      "currentMembersCount": 9,
      "startDate": "2026-08-16T00:00:00.000Z",
      "status": "UPCOMING"
    },
    {
      "id": "cc334992-bb83-419a-8b59-9ced58a09efd",
      "title": "جمعية شهر 8",
      "amount": "120000",
      "contributionAmount": "10000",
      "durationMonths": 12,
      "cycleFrequency": "MONTHLY",
      "memberCapacity": 12,
      "currentMembersCount": 5,
      "startDate": "2026-08-26T00:00:00.000Z",
      "status": "UPCOMING"
    },
    {
      "id": "03a098ac-a2be-4cfc-9358-53ecafd39a7f",
      "title": "جمعية شهر 8",
      "amount": "12000",
      "contributionAmount": "2000",
      "durationMonths": 6,
      "cycleFrequency": "MONTHLY",
      "memberCapacity": 6,
      "currentMembersCount": 0,
      "startDate": "2026-08-31T00:00:00.000Z",
      "status": "UPCOMING"
    }
  ],
  "meta": {
    "total": 3,
    "page": 1,
    "limit": 10,
    "totalPages": 1
  }
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ac79f810ad9d-MRS  content-encoding: br  content-length: 360  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:41:22 GMT  etag: W/"36d-qXu/JkmfYbD/1iUKRJBFirujIfs"  priority: u=1,i  rndr-id: ffe08cd5-4ab7-444e  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Paginated list of upcoming circles

| *No links* |
| ---------- |

**GET**

[**/customer/circles/{id}**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_getCircleDetail)

Get circle detail with structurally masked member view

#### Parameters

**Cancel**

| **NameDescription** |            |              |   |
| ------------------- | ---------- | ------------ | - |
| **id \***           | **string** | ***(path)*** |   |

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
{
  "id": "03a098ac-a2be-4cfc-9358-53ecafd39a7f",
  "title": "جمعية شهر 8",
  "amount": "12000",
  "contributionAmount": "2000",
  "durationMonths": 6,
  "cycleFrequency": "MONTHLY",
  "memberCapacity": 6,
  "currentMembersCount": 0,
  "startDate": "2026-08-31T00:00:00.000Z",
  "endDate": "2027-03-03T00:00:00.000Z",
  "status": "UPCOMING",
  "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
  "memberships": []
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3acd0fdb5ad9d-MRS  content-encoding: br  content-length: 279  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:41:36 GMT  etag: W/"177-sDmusNoAJ8oLyjR75PinWeY67Z8"  priority: u=1,i  rndr-id: 86e43d32-bf05-40bf  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Circle detail and masked members list

| *No links* |   |
| ---------- | - |
| 404        |   |

Circle not found

| *No links* |
| ---------- |

**GET**

[**/customer/home**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_getHomeRecommendations)

Customer home dashboard and recommended circles

#### Parameters

**Cancel**

No parameters

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/home' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/home
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
{
  "eligible": false,
  "reason": "eligibility_incomplete",
  "missingSteps": [
    "proof_of_income",
    "eligibility_decision"
  ]
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3acedac58ad9d-MRS  content-encoding: br  content-length: 80  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:41:40 GMT  etag: W/"6e-qmwFuKbpsPd3jfCLvsiCl0O4gB8"  priority: u=1,i  rndr-id: b07a0cea-e19a-4ce4  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Personalized recommendations and obligations summary

| *No links* |
| ---------- |

**GET**

[**/customer/my-circles**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_getMyCirclesProgress)

Customer joined circles progress list (تقدم الجمعيات)

#### Parameters

**Cancel**

No parameters

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/my-circles' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/my-circles
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
{
  "circles": []
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ad02894dad9d-MRS  content-encoding: br  content-length: 18  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:41:44 GMT  etag: W/"e-FsQ/Cpjt+ICNqliFjq0eppbnlZk"  priority: u=1,i  rndr-id: 32773b7b-553c-4265  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

List of user joined circles with progress metrics

| *No links* |
| ---------- |

**POST**

[**/customer/circles/{id}/join-intent**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_checkJoinIntent)

Pre-check eligibility and capacity before joining flow

#### Parameters

**Cancel**

| **NameDescription** |            |              |   |
| ------------------- | ---------- | ------------ | - |
| **id \***           | **string** | ***(path)*** |   |

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'POST' \
  'https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f/join-intent' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>' \
  -d ''
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f/join-intent
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 422      |             |

Error: response status is 422

##### Response body

**Download**

```
{
  "reason": "eligibility_incomplete",
  "missingSteps": [
    "proof_of_income",
    "eligibility_decision"
  ]
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ad258db3ad9d-MRS  content-encoding: br  content-length: 73  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:41:49 GMT  etag: W/"5d-Ak9fA7baWIK4Ehu0hjx+oZQNd/c"  priority: u=1,i  rndr-id: fd28d968-69d8-4cd7  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Customer is allowed to proceed to join flow

| *No links* |   |
| ---------- | - |
| 422        |   |

Pre-check failed with structured reason

| *No links* |
| ---------- |

**GET**

[**/customer/circles/{id}/positions**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_getPositionAvailability)

Near-real-time live position availability and fee preview

#### Parameters

**Cancel**

| **NameDescription** |            |              |   |
| ------------------- | ---------- | ------------ | - |
| **id \***           | **string** | ***(path)*** |   |

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f/positions' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f/positions
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
{
  "circleId": "03a098ac-a2be-4cfc-9358-53ecafd39a7f",
  "durationMonths": 6,
  "positions": [
    {
      "position": 1,
      "isAvailable": true,
      "feePreview": {
        "gross": "12000.00",
        "feeAmount": "960.00",
        "net": "11040.00",
        "feePercentage": "8.00"
      }
    },
    {
      "position": 2,
      "isAvailable": true,
      "feePreview": {
        "gross": "12000.00",
        "feeAmount": "840.00",
        "net": "11160.00",
        "feePercentage": "7.00"
      }
    },
    {
      "position": 3,
      "isAvailable": true,
      "feePreview": {
        "gross": "12000.00",
        "feeAmount": "480.00",
        "net": "11520.00",
        "feePercentage": "4.00"
      }
    },
    {
      "position": 4,
      "isAvailable": true,
      "feePreview": {
        "gross": "12000.00",
        "feeAmount": "0.00",
        "net": "12000.00",
        "feePercentage": "0.00"
      }
    },
    {
      "position": 5,
      "isAvailable": true,
      "feePreview": {
        "gross": "12000.00",
        "feeAmount": "-1800.00",
        "net": "13800.00",
        "feePercentage": "-15.00"
      }
    },
    {
      "position": 6,
      "isAvailable": true,
      "feePreview": {
        "gross": "12000.00",
        "feeAmount": "-2880.00",
        "net": "14880.00",
        "feePercentage": "-24.00"
      }
    }
  ]
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cache-control: no-store,no-cache,must-revalidate,max-age=0  cf-cache-status: DYNAMIC  cf-ray: a2a3ad40bd34ad9d-MRS  content-encoding: br  content-length: 235  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:41:54 GMT  etag: W/"360-wuGUfXEhrVvKS9XPW+vRDEN1phQ"  priority: u=1,i  rndr-id: 459b98b4-59eb-4e0c  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Position slots with fee calculation previews

| *No links* |
| ---------- |

**POST**

[**/customer/circles/{id}/join**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_startJoin)

ENDPOINT 1: Start join reservation (15-min TTL, draft contract generated)

#### Parameters

**Cancel**

| **NameDescription** |            |              |   |
| ------------------- | ---------- | ------------ | - |
| **id \***           | **string** | ***(path)*** |   |

#### Request body

**application/json**

- **Edit Value**
- Schema

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'POST' \
  'https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f/join' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
  "payoutPosition": 1,
  "paymentMethodId": "d3b07384-d113-46e4-a587-542f4c6e9389",
  "cardToken": "tok_visa_1234"
}'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/circles/03a098ac-a2be-4cfc-9358-53ecafd39a7f/join
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 422      |             |

Error: response status is 422

##### Response body

**Download**

```
{
  "reason": "eligibility_incomplete",
  "missingSteps": [
    "proof_of_income",
    "eligibility_decision"
  ]
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ad693dbfad9d-MRS  content-encoding: br  content-length: 73  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:42:00 GMT  etag: W/"5d-Ak9fA7baWIK4Ehu0hjx+oZQNd/c"  priority: u=1,i  rndr-id: 8e213b61-1ddc-4131  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 201      |                 |           |

Position reserved successfully, draft contract reference returned

| *No links* |   |
| ---------- | - |
| 409        |   |

Position taken

| *No links* |   |
| ---------- | - |
| 422        |   |

Eligibility, capacity, or overdue installment check failed

| *No links* |
| ---------- |

**POST**

[**/customer/join/{membershipId}/contract/accept**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_acceptContract)

ENDPOINT 3: Accept contract terms & request signature OTP

#### Parameters

**Cancel**

| **NameDescription** |            |              |   |
| ------------------- | ---------- | ------------ | - |
| **membershipId \*** | **string** | ***(path)*** |   |

#### Request body

**application/json**

- **Edit Value**
- Schema

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'POST' \
  'https://jameya-backend.onrender.com/customer/join/03a098ac-a2be-4cfc-9358-53ecafd39a7f/contract/accept' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
  "agreedToTerms": true,
  "agreedToInstallmentSchedule": true,
  "agreedToLateFees": true
}'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/join/03a098ac-a2be-4cfc-9358-53ecafd39a7f/contract/accept
```

#### Server response

| **Code** | **Details**        |   |
| :------- | :----------------- | - |
| 404      | ***Undocumented*** |   |

Error: response status is 404

##### Response body

**Download**

```
{
  "message": "Membership reservation not found",
  "error": "Not Found",
  "statusCode": 404
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ada68f1dad9d-MRS  content-encoding: br  content-length: 78  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:42:10 GMT  etag: W/"53-D4IywOXahrb7aTHNhumIBPS+Fvc"  priority: u=1,i  rndr-id: 73f2b573-9755-4c5c  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Explicit consent accepted and signature OTP sent

| *No links* |   |
| ---------- | - |
| 410        |   |

Reservation expired

| *No links* |
| ---------- |

**POST**

[**/customer/join/{membershipId}/contract/verify-otp**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_verifyContractOtp)

ENDPOINT 4: Verify signature OTP & finalize membership

**GET**

[**/customer/history**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Circles%20&%20Home%20Discovery/CustomerCirclesController_getCustomerHistory)

Get unified customer dashboard summary & historical activity feed (GET /customer/history)

### [Admin – Audit Log Viewer (ADM-15)](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Audit%20Log%20Viewer%20\(ADM-15\))

**GET**

[**/admin/audit**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Audit%20Log%20Viewer%20\(ADM-15\)/AuditController_getAuditEvents)

Search & query administrative audit logs (ADM-15)

### [Customer – Signed Contracts (FR-10)](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Signed%20Contracts%20\(FR-10\))

**GET**

[**/customer/contracts**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Signed%20Contracts%20\(FR-10\)/ContractsController_getMyContracts)

List all signed contracts for the authenticated customer (FR-10)

#### Parameters

**Cancel**

No parameters

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/contracts' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/contracts
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
[]
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ade13e07ad9d-MRS  content-encoding: br  content-length: 6  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:42:19 GMT  etag: W/"2-l9Fw4VUO7kr8CvBlt4zaMCqXZ0w"  priority: u=1,i  rndr-id: 45c279ef-23ac-4a04  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

List of signed contracts with cryptographic hashes

| *No links* |
| ---------- |

**GET**

[**/customer/contracts/{membershipId}**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Signed%20Contracts%20\(FR-10\)/ContractsController_getContractByMembershipId)

Get signed contract details by membership ID (FR-10)

#### Parameters

**Cancel**

| **NameDescription** |            |              |   |
| ------------------- | ---------- | ------------ | - |
| **membershipId \*** | **string** | ***(path)*** |   |

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/contracts/03a098ac-a2be-4cfc-9358-53ecafd39a7f' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/contracts/03a098ac-a2be-4cfc-9358-53ecafd39a7f
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 404      |             |

Error: response status is 404

##### Response body

**Download**

```
{
  "message": "Signed contract not found for this membership",
  "error": "Not Found",
  "statusCode": 404
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ae051a96ad9d-MRS  content-encoding: br  content-length: 89  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:42:25 GMT  etag: W/"60-oEK2/VvdiNtwC6Yrg7CnEaciSeI"  priority: u=1,i  rndr-id: 8d8b6122-3122-4826  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Contract details, PDF reference, and signature evidence

| *No links* |   |
| ---------- | - |
| 404        |   |

Contract not found

| *No links* |
| ---------- |

**GET**

[**/customer/contracts/{membershipId}/download**](https://jameya-backend.onrender.com/api-docs#/Customer%20%E2%80%93%20Signed%20Contracts%20\(FR-10\)/ContractsController_downloadContract)

Download contract as PDF (draft or signed) (FR-10)

### [Customer - Payment Methods](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Payment%20Methods)

**GET**

[**/customer/payment-methods**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Payment%20Methods/CustomerPaymentMethodsController_getPaymentMethods)

Get saved payment methods on customer profile

#### Parameters

**Cancel**

No parameters

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/customer/payment-methods' \
  -H 'accept: */*'
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/payment-methods
```

#### Server response

| **Code** | **Details**        |   |
| :------- | :----------------- | - |
| 401      | ***Undocumented*** |   |

Error: response status is 401

##### Response body

**Download**

```
{
  "message": "Unauthorized",
  "statusCode": 401
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3ae68bc96ad9d-MRS  content-encoding: br  content-length: 47  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:42:41 GMT  etag: W/"2b-dGnJzt6gv1nJjX6DJ9RztDWptng"  priority: u=1,i  rndr-id: 58d8b026-1d5c-4697  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links**  |
| :------- | :-------------- | :--------- |
| 200      |                 | *No links* |

**POST**

[**/customer/payment-methods/verify**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Payment%20Methods/CustomerPaymentMethodsController_verifyAndAddCard)

Verify and save a new Visa/Card token to customer profile

#### Parameters

**Cancel**

No parameters

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'POST' \
  'https://jameya-backend.onrender.com/customer/payment-methods/verify' \
  -H 'accept: */*' \
  -d ''
```

#### Request URL

```
https://jameya-backend.onrender.com/customer/payment-methods/verify
```

#### Server response

| **Code** | **Details**        |   |
| :------- | :----------------- | - |
| 401      | ***Undocumented*** |   |

Error: response status is 401

##### Response body

**Download**

```
{
  "message": "Unauthorized",
  "statusCode": 401
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3aea0b8d3ad9d-MRS  content-encoding: br  content-length: 47  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:42:50 GMT  etag: W/"2b-dGnJzt6gv1nJjX6DJ9RztDWptng"  priority: u=1,i  rndr-id: 6eb47f5a-df6b-45d4  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links**  |
| :------- | :-------------- | :--------- |
| 201      |                 | *No links* |

**PATCH**

[**/customer/payment-methods/{id}/set-default**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Payment%20Methods/CustomerPaymentMethodsController_setDefault)

Set default payment method

**DELETE**

[**/customer/payment-methods/{id}**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Payment%20Methods/CustomerPaymentMethodsController_deletePaymentMethod)

Remove a payment method from customer profile

### [Webhooks - Payments](https://jameya-backend.onrender.com/api-docs#/Webhooks%20-%20Payments)

**POST**

[**/payments/webhook/gateway**](https://jameya-backend.onrender.com/api-docs#/Webhooks%20-%20Payments/PaymentsWebhookController_handleGatewayWebhook)

Handle Card Gateway Callback Webhook (Idempotent)

### [Customer / Notifications](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Notifications)

**GET**

[**/customer/notifications**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Notifications/NotificationsController_getNotifications)

Get customer in-app notifications (paginated, filter by ?unread=true)

**GET**

[**/customer/notifications/unread-count**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Notifications/NotificationsController_getUnreadCount)

Get unread notification count badge counter

**PATCH**

[**/customer/notifications/read-all**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Notifications/NotificationsController_markAllAsRead)

Mark all notifications as read for current customer

**PATCH**

[**/customer/notifications/{id}/read**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Notifications/NotificationsController_markAsRead)

Mark a specific notification as read by ID

### [Customer / Profile & Verification](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Profile%20&%20Verification)

**GET**

[**/customers/profile**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Profile%20&%20Verification/CustomersController_getProfile)

Get authenticated customer profile (name, email, phone, status)

**POST**

[**/customers/profile**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Profile%20&%20Verification/CustomersController_completeProfile)

Submit or update legal identity profile details

**POST**

[**/customers/documents**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Profile%20&%20Verification/CustomersController_uploadDocument)

Upload verification document (National ID, Income Proof, etc.)

**POST**

[**/customers/kyc/submit**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Profile%20&%20Verification/CustomersController_submitKycForReview)

Submit KYC for admin review

**GET**

[**/customers/kyc-status**](https://jameya-backend.onrender.com/api-docs#/Customer%20/%20Profile%20&%20Verification/CustomersController_getKycStatus)

Get aggregated customer KYC status, documents, and eligibility

### [Admin – Auth](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Auth)

**POST**

[**/admin/auth/login**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Auth/AdminAuthController_login)

Admin login with email and password

#### Parameters

**Cancel**

No parameters

#### Request body

**application/json**

- **Edit Value**
- Schema

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'POST' \
  'https://jameya-backend.onrender.com/admin/auth/login' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "admin@jameya.local",
  "password": "ChangeMe123!"
}'
```

#### Request URL

```
https://jameya-backend.onrender.com/admin/auth/login
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjOGY5MzJhZS03NTg5LTQxYjItYjljZi1kOGU2ZmU3YzFiMTgiLCJlbWFpbCI6ImFkbWluQGphbWV5YS5sb2NhbCIsInJvbGUiOiJTVVBFUl9BRE1JTiIsInR5cGUiOiJhZG1pbiIsImlhdCI6MTc4NjU4MTI4NCwiZXhwIjoxNzg2NTgyMTg0fQ.P7NYQ4QQ1GcFTy4DE0TgGCHIey5z6FVqFIx2L8jjofY",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjOGY5MzJhZS03NTg5LTQxYjItYjljZi1kOGU2ZmU3YzFiMTgiLCJlbWFpbCI6ImFkbWluQGphbWV5YS5sb2NhbCIsInJvbGUiOiJTVVBFUl9BRE1JTiIsInR5cGUiOiJhZG1pbiIsImlhdCI6MTc4NjU4MTI4NCwiZXhwIjoxNzg2NjEwMDg0fQ.U1nKFSm36L-AsSDOim0KndkNHmllg-hy6kGxfTI1QBI"
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3a2c04e94cb4b-MRS  content-encoding: br  content-length: 293  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:34:44 GMT  etag: W/"24a-XUv/huvZgTouVySX8XrSWksxjjI"  priority: u=1,i  rndr-id: 53805fa2-40aa-4e16  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 200      |                 |           |

Returns JWT access + refresh token pair

| *No links* |   |
| ---------- | - |
| 401        |   |

Invalid credentials or inactive account

| *No links* |
| ---------- |

**POST**

[**/admin/auth/refresh**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Auth/AdminAuthController_refresh)

Rotate admin refresh token

**POST**

[**/admin/auth/logout**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Auth/AdminAuthController_logout)

Revoke all active admin sessions

### [Admin – Profile](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Profile)

**GET**

[**/admin/profile**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Profile/AdminProfileController_getProfile)

Get the logged-in admin's own profile

**PATCH**

[**/admin/profile/password**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Profile/AdminProfileController_changePassword)

Change own password (revokes all existing sessions)

### [Admin – Dashboard](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Dashboard)

**GET**

[**/admin/dashboard**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Dashboard/DashboardController_getStats)

Get aggregated admin dashboard statistics

### [Admin – User Management](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20User%20Management)

**GET**

[**/admin/users**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20User%20Management/AdminUsersController_listAdmins)

List all admin accounts

**POST**

[**/admin/users**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20User%20Management/AdminUsersController_createAdmin)

Create a new admin account

**PATCH**

[**/admin/users/{id}/status**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20User%20Management/AdminUsersController_updateStatus)

Update admin account status (suspend / reactivate) — reason required

**PATCH**

[**/admin/users/{id}/role**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20User%20Management/AdminUsersController_updateRole)

Change the role assigned to an admin — reason required

### [Admin – Customers](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Customers)

**GET**

[**/admin/customers**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Customers/AdminCustomersController_listCustomers)

List customers with pagination and filters

**GET**

[**/admin/customers/{id}**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Customers/AdminCustomersController_getCustomer)

Get full customer profile including KYC, documents, and memberships

**PATCH**

[**/admin/customers/{id}/status**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Customers/AdminCustomersController_updateStatus)

Update customer account status — reason required

### [Admin – Payments](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Payments)

**GET**

[**/admin/payment-proofs**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Payments/AdminPaymentsController_listPendingProofs)

List all pending manual payment proof submissions

**PATCH**

[**/admin/payment-proofs/{id}/review**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Payments/AdminPaymentsController_reviewProof)

Approve or reject a payment proof — reason required on REJECTED

**PATCH**

[**/admin/payment-proofs/{id}/flag**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Payments/AdminPaymentsController_flagProof)

Flag a payment proof for investigation — reason required

**PATCH**

[**/admin/transactions/{id}/hold**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Payments/AdminPaymentsController_holdTransaction)

Place a transaction on hold for investigation — reason required

### [Admin – Roles](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Roles)

**GET**

[**/admin/roles**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Roles/RolesController_listRoles)

List all available roles — used to populate role picker when creating admins

### [Admin – Circles](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Circles)

**POST**

[**/admin/circles**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Circles/AdminCirclesController_createCircle)

Create a new circle draft (auto-looks up active fee policy)

#### Parameters

**CancelReset**

No parameters

#### Request body

**application/json**

- **Edit Value**
- Schema

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'POST' \
  'https://jameya-backend.onrender.com/admin/circles' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>' \
  -H 'Content-Type: application/json' \
  -d '{
  "amount": 10000,
  "contributionAmount": 1000,
  "durationMonths": 10,
  "memberCapacity": 10,
  "cycleFrequency": "MONTHLY",
  "startDate": "2026-12-01T00:00:00.000Z"
}'
```

#### Request URL

```
https://jameya-backend.onrender.com/admin/circles
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 201      |             |

##### Response body

**Download**

```
{
  "id": "64435e07-a84c-4430-bd89-ef0e0f856a0a",
  "amount": "10000",
  "contributionAmount": "1000",
  "durationMonths": 10,
  "cycleFrequency": "MONTHLY",
  "memberCapacity": 10,
  "currentMembersCount": 0,
  "startDate": "2026-12-01T00:00:00.000Z",
  "endDate": "2027-10-01T00:00:00.000Z",
  "status": "DRAFT",
  "feePolicyId": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
  "feePolicySnapshot": {
    "1": 14,
    "2": 12,
    "3": 10,
    "4": 8,
    "5": 6,
    "6": 0,
    "7": 0,
    "8": -5,
    "9": -7,
    "10": -10
  },
  "createdAt": "2026-08-13T00:36:07.026Z",
  "updatedAt": "2026-08-13T00:36:07.026Z",
  "feePolicy": {
    "id": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
    "durationMonths": 10,
    "positionFees": {
      "1": 14,
      "2": 12,
      "3": 10,
      "4": 8,
      "5": 6,
      "6": 0,
      "7": 0,
      "8": -5,
      "9": -7,
      "10": -10
    },
    "version": "v1.0-10m",
    "status": "ACTIVE",
    "effectiveFrom": "2026-08-11T11:21:36.428Z",
    "createdAt": "2026-08-11T11:21:36.428Z"
  },
  "memberships": [],
  "circleCode": "JMY-2026-64435E",
  "overview": {
    "totalValue": 10000,
    "collectedAmount": 0,
    "remainingAmount": 10000,
    "completionPercentage": 0,
    "currentMonthGauge": {
      "currentCycleNumber": 1,
      "targetAmount": 10000,
      "collectedAmount": 0,
      "paidCount": 0,
      "totalMembersCount": 10
    }
  },
  "formattedMembers": [],
  "paymentsSummary": {
    "totalRounds": 10,
    "completedRounds": 0,
    "partialRounds": 0,
    "overdueRounds": 0,
    "upcomingRounds": 10,
    "cycles": [
      {
        "cycleNumber": 1,
        "dueDate": "2026-12-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 2,
        "dueDate": "2027-01-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 3,
        "dueDate": "2027-02-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 4,
        "dueDate": "2027-03-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 5,
        "dueDate": "2027-04-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 6,
        "dueDate": "2027-05-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 7,
        "dueDate": "2027-06-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 8,
        "dueDate": "2027-07-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 9,
        "dueDate": "2027-08-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      },
      {
        "cycleNumber": 10,
        "dueDate": "2027-09-01T00:00:00.000Z",
        "status": "UPCOMING",
        "totalAmount": 10000,
        "collectedAmount": 0,
        "paidCount": 0,
        "pendingCount": 0,
        "overdueCount": 0,
        "failedCount": 0,
        "totalMembersCount": 10
      }
    ]
  }
}
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3a4c78c6b2e37-MRS  content-encoding: br  content-length: 674  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:36:07 GMT  etag: W/"c92-jVk8dv6fdzL2IWDfhEvMHBWdqVc"  priority: u=1,i  rndr-id: 33fcc856-52cc-4d3c  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links** |
| :------- | :-------------- | :-------- |
| 201      |                 |           |

Circle created in DRAFT status

| *No links* |   |
| ---------- | - |
| 400        |   |

Invalid business logic (amount/capacity mismatch)

| *No links* |   |
| ---------- | - |
| 422        |   |

No active fee policy found for duration

| *No links* |
| ---------- |

**GET**

[**/admin/circles**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Circles/AdminCirclesController_getAllCircles)

List all circles with optional status filter

#### Parameters

**Cancel**

| **NameDescription** |            |               |                                                   |
| ------------------- | ---------- | ------------- | ------------------------------------------------- |
| status              | **string** | ***(query)*** | **--DRAFTUPCOMINGIN\_PROGRESSCOMPLETEDCANCELLED** |

**ExecuteClear**

#### Responses

#### Curl

```
curl -X 'GET' \
  'https://jameya-backend.onrender.com/admin/circles' \
  -H 'accept: */*' \
  -H 'Authorization: Bearer <JWT_ACCESS_TOKEN>'
```

#### Request URL

```
https://jameya-backend.onrender.com/admin/circles
```

#### Server response

| **Code** | **Details** |
| :------- | :---------- |
| 200      |             |

##### Response body

**Download**

```
[
  {
    "id": "64435e07-a84c-4430-bd89-ef0e0f856a0a",
    "amount": "10000",
    "contributionAmount": "1000",
    "durationMonths": 10,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 10,
    "currentMembersCount": 0,
    "startDate": "2026-12-01T00:00:00.000Z",
    "endDate": "2027-10-01T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
    "feePolicySnapshot": {
      "1": 14,
      "2": 12,
      "3": 10,
      "4": 8,
      "5": 6,
      "6": 0,
      "7": 0,
      "8": -5,
      "9": -7,
      "10": -10
    },
    "createdAt": "2026-08-13T00:36:07.026Z",
    "updatedAt": "2026-08-13T00:36:07.026Z",
    "feePolicy": {
      "id": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
      "durationMonths": 10,
      "positionFees": {
        "1": 14,
        "2": 12,
        "3": 10,
        "4": 8,
        "5": 6,
        "6": 0,
        "7": 0,
        "8": -5,
        "9": -7,
        "10": -10
      },
      "version": "v1.0-10m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:36.428Z",
      "createdAt": "2026-08-11T11:21:36.428Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "6fee8958-a017-4d3f-ab75-3a3ccc086a0f",
    "amount": "10000",
    "contributionAmount": "1000",
    "durationMonths": 10,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 10,
    "currentMembersCount": 0,
    "startDate": "2026-09-01T00:00:00.000Z",
    "endDate": "2027-07-01T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
    "feePolicySnapshot": {
      "1": 14,
      "2": 12,
      "3": 10,
      "4": 8,
      "5": 6,
      "6": 0,
      "7": 0,
      "8": -5,
      "9": -7,
      "10": -10
    },
    "createdAt": "2026-08-13T00:35:55.272Z",
    "updatedAt": "2026-08-13T00:35:55.272Z",
    "feePolicy": {
      "id": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
      "durationMonths": 10,
      "positionFees": {
        "1": 14,
        "2": 12,
        "3": 10,
        "4": 8,
        "5": 6,
        "6": 0,
        "7": 0,
        "8": -5,
        "9": -7,
        "10": -10
      },
      "version": "v1.0-10m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:36.428Z",
      "createdAt": "2026-08-11T11:21:36.428Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "0799e29c-4a51-48b9-9e3d-431c1d1cd036",
    "amount": "6000",
    "contributionAmount": "1000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 0,
    "startDate": "2026-08-30T00:00:00.000Z",
    "endDate": "2027-03-02T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-13T00:17:29.426Z",
    "updatedAt": "2026-08-13T00:17:29.426Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "45d844d8-cc5a-436f-a20c-a0936ff85d62",
    "amount": "6000",
    "contributionAmount": "1000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 0,
    "startDate": "2026-08-12T00:00:00.000Z",
    "endDate": "2027-02-12T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-12T23:36:05.778Z",
    "updatedAt": "2026-08-12T23:36:05.778Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "9aaf9ed4-e9e4-4ea6-b040-164ced106b1e",
    "amount": "6000",
    "contributionAmount": "1000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 0,
    "startDate": "2026-08-13T00:00:00.000Z",
    "endDate": "2027-02-13T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-12T23:30:45.251Z",
    "updatedAt": "2026-08-12T23:30:45.251Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "fa704594-7da0-40e6-9700-25cbabb76b4e",
    "amount": "10000",
    "contributionAmount": "1000",
    "durationMonths": 10,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 10,
    "currentMembersCount": 0,
    "startDate": "2026-09-01T00:00:00.000Z",
    "endDate": "2027-07-01T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
    "feePolicySnapshot": {
      "1": 14,
      "2": 12,
      "3": 10,
      "4": 8,
      "5": 6,
      "6": 0,
      "7": 0,
      "8": -5,
      "9": -7,
      "10": -10
    },
    "createdAt": "2026-08-12T23:19:25.309Z",
    "updatedAt": "2026-08-12T23:19:25.309Z",
    "feePolicy": {
      "id": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
      "durationMonths": 10,
      "positionFees": {
        "1": 14,
        "2": 12,
        "3": 10,
        "4": 8,
        "5": 6,
        "6": 0,
        "7": 0,
        "8": -5,
        "9": -7,
        "10": -10
      },
      "version": "v1.0-10m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:36.428Z",
      "createdAt": "2026-08-11T11:21:36.428Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "64e7a027-0f1b-474c-ac08-c37258e5bbc3",
    "amount": "36000",
    "contributionAmount": "3000",
    "durationMonths": 12,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 12,
    "currentMembersCount": 0,
    "startDate": "2026-08-12T00:00:00.000Z",
    "endDate": "2027-08-12T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "236cbefa-0bdf-44cd-abc6-836770132dac",
    "feePolicySnapshot": {
      "1": 16,
      "2": 14,
      "3": 12,
      "4": 10,
      "5": 8,
      "6": 6,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": -7,
      "11": -10,
      "12": -12
    },
    "createdAt": "2026-08-12T23:18:31.756Z",
    "updatedAt": "2026-08-12T23:18:31.756Z",
    "feePolicy": {
      "id": "236cbefa-0bdf-44cd-abc6-836770132dac",
      "durationMonths": 12,
      "positionFees": {
        "1": 16,
        "2": 14,
        "3": 12,
        "4": 10,
        "5": 8,
        "6": 6,
        "7": 0,
        "8": 0,
        "9": 0,
        "10": -7,
        "11": -10,
        "12": -12
      },
      "version": "v1.0-12m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:37.253Z",
      "createdAt": "2026-08-11T11:21:37.254Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "e1f135a3-d896-4557-ad2e-6e2737e3f807",
    "amount": "12000",
    "contributionAmount": "2000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 0,
    "startDate": "2026-08-12T00:00:00.000Z",
    "endDate": "2027-02-12T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-12T23:16:33.299Z",
    "updatedAt": "2026-08-12T23:16:33.299Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "e9195955-bd39-4728-92cc-dd80c200a0c4",
    "amount": "18000",
    "contributionAmount": "3000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 0,
    "startDate": "2026-08-12T00:00:00.000Z",
    "endDate": "2027-02-12T00:00:00.000Z",
    "status": "DRAFT",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-12T21:11:33.151Z",
    "updatedAt": "2026-08-12T21:11:33.151Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "dd07610a-305f-4d28-af95-dbb33345e6a2",
    "amount": "30000",
    "contributionAmount": "5000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 2,
    "startDate": "2026-08-21T00:00:00.000Z",
    "endDate": "2027-02-21T00:00:00.000Z",
    "status": "CANCELLED",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-11T11:22:15.440Z",
    "updatedAt": "2026-08-12T03:30:58.735Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 2
    }
  },
  {
    "id": "34e9779c-9a23-44f4-b302-d3ae28e073f7",
    "amount": "180000",
    "contributionAmount": "15000",
    "durationMonths": 12,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 12,
    "currentMembersCount": 12,
    "startDate": "2026-07-11T00:00:00.000Z",
    "endDate": "2027-07-11T00:00:00.000Z",
    "status": "IN_PROGRESS",
    "feePolicyId": "236cbefa-0bdf-44cd-abc6-836770132dac",
    "feePolicySnapshot": {
      "1": 16,
      "2": 14,
      "3": 12,
      "4": 10,
      "5": 8,
      "6": 6,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": -7,
      "11": -10,
      "12": -12
    },
    "createdAt": "2026-08-11T11:22:11.037Z",
    "updatedAt": "2026-08-11T11:22:11.037Z",
    "feePolicy": {
      "id": "236cbefa-0bdf-44cd-abc6-836770132dac",
      "durationMonths": 12,
      "positionFees": {
        "1": 16,
        "2": 14,
        "3": 12,
        "4": 10,
        "5": 8,
        "6": 6,
        "7": 0,
        "8": 0,
        "9": 0,
        "10": -7,
        "11": -10,
        "12": -12
      },
      "version": "v1.0-12m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:37.253Z",
      "createdAt": "2026-08-11T11:21:37.254Z"
    },
    "_count": {
      "memberships": 12
    }
  },
  {
    "id": "a712dc21-4f12-4d49-a114-35e5bf5cf340",
    "amount": "30000",
    "contributionAmount": "3000",
    "durationMonths": 10,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 10,
    "currentMembersCount": 9,
    "startDate": "2026-08-16T00:00:00.000Z",
    "endDate": "2027-06-16T00:00:00.000Z",
    "status": "UPCOMING",
    "feePolicyId": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
    "feePolicySnapshot": {
      "1": 14,
      "2": 12,
      "3": 10,
      "4": 8,
      "5": 6,
      "6": 0,
      "7": 0,
      "8": -5,
      "9": -7,
      "10": -10
    },
    "createdAt": "2026-08-11T11:22:08.491Z",
    "updatedAt": "2026-08-11T11:22:08.491Z",
    "feePolicy": {
      "id": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
      "durationMonths": 10,
      "positionFees": {
        "1": 14,
        "2": 12,
        "3": 10,
        "4": 8,
        "5": 6,
        "6": 0,
        "7": 0,
        "8": -5,
        "9": -7,
        "10": -10
      },
      "version": "v1.0-10m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:36.428Z",
      "createdAt": "2026-08-11T11:21:36.428Z"
    },
    "_count": {
      "memberships": 10
    }
  },
  {
    "id": "03a098ac-a2be-4cfc-9358-53ecafd39a7f",
    "amount": "12000",
    "contributionAmount": "2000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 0,
    "startDate": "2026-08-31T00:00:00.000Z",
    "endDate": "2027-03-03T00:00:00.000Z",
    "status": "UPCOMING",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-11T11:22:08.301Z",
    "updatedAt": "2026-08-11T11:22:08.301Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 0
    }
  },
  {
    "id": "cc334992-bb83-419a-8b59-9ced58a09efd",
    "amount": "120000",
    "contributionAmount": "10000",
    "durationMonths": 12,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 12,
    "currentMembersCount": 5,
    "startDate": "2026-08-26T00:00:00.000Z",
    "endDate": "2027-08-26T00:00:00.000Z",
    "status": "UPCOMING",
    "feePolicyId": "236cbefa-0bdf-44cd-abc6-836770132dac",
    "feePolicySnapshot": {
      "1": 16,
      "2": 14,
      "3": 12,
      "4": 10,
      "5": 8,
      "6": 6,
      "7": 0,
      "8": 0,
      "9": 0,
      "10": -7,
      "11": -10,
      "12": -12
    },
    "createdAt": "2026-08-11T11:22:06.839Z",
    "updatedAt": "2026-08-11T11:22:06.839Z",
    "feePolicy": {
      "id": "236cbefa-0bdf-44cd-abc6-836770132dac",
      "durationMonths": 12,
      "positionFees": {
        "1": 16,
        "2": 14,
        "3": 12,
        "4": 10,
        "5": 8,
        "6": 6,
        "7": 0,
        "8": 0,
        "9": 0,
        "10": -7,
        "11": -10,
        "12": -12
      },
      "version": "v1.0-12m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:37.253Z",
      "createdAt": "2026-08-11T11:21:37.254Z"
    },
    "_count": {
      "memberships": 5
    }
  },
  {
    "id": "54ff791e-d2ca-4520-a192-7260ea1cd780",
    "amount": "6000",
    "contributionAmount": "1000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 6,
    "startDate": "2025-12-11T00:00:00.000Z",
    "endDate": "2026-06-11T00:00:00.000Z",
    "status": "COMPLETED",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-11T11:22:03.664Z",
    "updatedAt": "2026-08-11T11:22:03.664Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 1
    }
  },
  {
    "id": "66484754-6a8b-4103-8a3e-443d07e8326e",
    "amount": "30000",
    "contributionAmount": "5000",
    "durationMonths": 6,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 6,
    "currentMembersCount": 6,
    "startDate": "2026-07-11T00:00:00.000Z",
    "endDate": "2027-01-11T00:00:00.000Z",
    "status": "IN_PROGRESS",
    "feePolicyId": "01841805-e4d1-4003-8911-225af1a13414",
    "feePolicySnapshot": {
      "1": 8,
      "2": 7,
      "3": 4,
      "4": 0,
      "5": -15,
      "6": -24
    },
    "createdAt": "2026-08-11T11:22:00.107Z",
    "updatedAt": "2026-08-11T11:22:00.107Z",
    "feePolicy": {
      "id": "01841805-e4d1-4003-8911-225af1a13414",
      "durationMonths": 6,
      "positionFees": {
        "1": 8,
        "2": 7,
        "3": 4,
        "4": 0,
        "5": -15,
        "6": -24
      },
      "version": "v1.0-6m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:35.605Z",
      "createdAt": "2026-08-11T11:21:35.608Z"
    },
    "_count": {
      "memberships": 1
    }
  },
  {
    "id": "689cd0d2-6934-456a-b8eb-85bb94711c10",
    "amount": "20000",
    "contributionAmount": "2000",
    "durationMonths": 10,
    "cycleFrequency": "MONTHLY",
    "memberCapacity": 10,
    "currentMembersCount": 10,
    "startDate": "2026-06-11T00:00:00.000Z",
    "endDate": "2027-04-11T00:00:00.000Z",
    "status": "IN_PROGRESS",
    "feePolicyId": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
    "feePolicySnapshot": {
      "1": 14,
      "2": 12,
      "3": 10,
      "4": 8,
      "5": 6,
      "6": 0,
      "7": 0,
      "8": -5,
      "9": -7,
      "10": -10
    },
    "createdAt": "2026-08-11T11:21:50.957Z",
    "updatedAt": "2026-08-11T11:21:50.957Z",
    "feePolicy": {
      "id": "fc0c48a1-8199-4106-9d1b-a9cc3a61653a",
      "durationMonths": 10,
      "positionFees": {
        "1": 14,
        "2": 12,
        "3": 10,
        "4": 8,
        "5": 6,
        "6": 0,
        "7": 0,
        "8": -5,
        "9": -7,
        "10": -10
      },
      "version": "v1.0-10m",
      "status": "ACTIVE",
      "effectiveFrom": "2026-08-11T11:21:36.428Z",
      "createdAt": "2026-08-11T11:21:36.428Z"
    },
    "_count": {
      "memberships": 10
    }
  }
]
```

##### Response headers

```
 access-control-allow-origin: *  alt-svc: h3=":443"; ma=86400  cf-cache-status: DYNAMIC  cf-ray: a2a3a50949c62e37-MRS  content-encoding: br  content-length: 1469  content-type: application/json; charset=utf-8  date: Thu,13 Aug 2026 00:36:17 GMT  etag: W/"3404-39oNmXAQDUWxTkYAkt10Yz8bmMw"  priority: u=1,i  rndr-id: d9ea71f5-c1a6-46cd  server: cloudflare  server-timing: cfExtPri  vary: Accept-Encoding  x-powered-by: Express  x-render-origin-server: Render 
```

#### Responses

| **Code** | **Description** | **Links**  |
| :------- | :-------------- | :--------- |
| 200      |                 | *No links* |

**GET**

[**/admin/circles/{id}**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Circles/AdminCirclesController_getCircleById)

Get a single circle by ID (includes memberships)

**PATCH**

[**/admin/circles/{id}**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Circles/AdminCirclesController_updateCircleProperties)

Edit circle properties — only core property changes past DRAFT require a reason (BR-05)

**PATCH**

[**/admin/circles/{id}/activate**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Circles/AdminCirclesController_activateCircle)

Activate a DRAFT circle — moves it to UPCOMING and locks fee policy

**PATCH**

[**/admin/circles/{id}/cancel**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Circles/AdminCirclesController_cancelCircle)

Cancel a circle at any stage — reason required (SRS 8.1)

### [Admin – Memberships (ADM-07 Exceptions)](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Memberships%20\(ADM-07%20Exceptions\))

**GET**

[**/admin/memberships**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Memberships%20\(ADM-07%20Exceptions\)/AdminMembershipsController_getMemberships)

List memberships — filter by status=pending\_signature or usedEligibilityOverride=true (ADM-07)

**POST**

[**/admin/memberships/{id}/release**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Memberships%20\(ADM-07%20Exceptions\)/AdminMembershipsController_releaseMembership)

Manual admin release of a stuck PENDING\_SIGNATURE reservation — requires reason (ADM-07)

**POST**

[**/admin/memberships/{id}/mark-defaulted**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Memberships%20\(ADM-07%20Exceptions\)/AdminMembershipsController_markDefaulted)

Mark a delinquent membership as DEFAULTED — requires reason and writes audit log

### [Admin - Installments](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Installments)

**GET**

[**/admin/installments**](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Installments/AdminInstallmentsController_getInstallments)

Get installments filterable by status, search, with pagination

**GET**

[**/admin/installments/{id}**](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Installments/AdminInstallmentsController_getInstallmentDetail)

Get late payment installment detail by ID

### [Admin - Transactions](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Transactions)

**GET**

[**/admin/transactions**](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Transactions/AdminTransactionsController_getTransactions)

Get transactions for payment review with status tabs, search, and pagination

### [Admin - Payouts](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Payouts)

**GET**

[**/admin/payouts**](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Payouts/AdminPayoutsController_getPayouts)

List payouts with status filter, search, summary header, and pagination

**PATCH**

[**/admin/payouts/{id}/confirm**](https://jameya-backend.onrender.com/api-docs#/Admin%20-%20Payouts/AdminPayoutsController_confirmPayout)

Single admin action to confirm and disburse payout (idempotent)

### [Admin / KYC & Eligibility](https://jameya-backend.onrender.com/api-docs#/Admin%20/%20KYC%20&%20Eligibility)

**GET**

[**/admin/kyc/pending-documents**](https://jameya-backend.onrender.com/api-docs#/Admin%20/%20KYC%20&%20Eligibility/KycController_getPendingDocuments)

List all submitted documents awaiting admin review

**PATCH**

[**/admin/kyc/documents/{id}/review**](https://jameya-backend.onrender.com/api-docs#/Admin%20/%20KYC%20&%20Eligibility/KycController_reviewDocument)

Approve or reject a submitted customer document

**POST**

[**/admin/kyc/eligibility**](https://jameya-backend.onrender.com/api-docs#/Admin%20/%20KYC%20&%20Eligibility/KycController_createEligibilityDecision)

Assign trust score and participation budget/limit to customer

### [Admin – Financial & Operational Reports (ADM-13)](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Financial%20&%20Operational%20Reports%20\(ADM-13\))

**GET**

[**/admin/reports/collections**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Financial%20&%20Operational%20Reports%20\(ADM-13\)/ReportsController_getCollectionsReport)

Collection rate, due vs paid amounts, and channel breakdown (ADM-13)

**GET**

[**/admin/reports/customers**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Financial%20&%20Operational%20Reports%20\(ADM-13\)/ReportsController_getCustomersReport)

Customer status distribution, active obligations, and KYC breakdown (ADM-13)

**GET**

[**/admin/reports/risk**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Financial%20&%20Operational%20Reports%20\(ADM-13\)/ReportsController_getRiskReport)

Risk score distribution, average trust score, and manual overrides (ADM-13)

**GET**

[**/admin/reports/audit**](https://jameya-backend.onrender.com/api-docs#/Admin%20%E2%80%93%20Financial%20&%20Operational%20Reports%20\(ADM-13\)/ReportsController_getAuditReport)

Summary of administrative activity by action type and admin user (ADM-13)

### [Storage / File Upload](https://jameya-backend.onrender.com/api-docs#/Storage%20/%20File%20Upload)

**POST**

[**/storage/upload**](https://jameya-backend.onrender.com/api-docs#/Storage%20/%20File%20Upload/StorageController_uploadFile)

Upload a KYC document file to Cloudinary

### [Customer - Installments](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Installments)

**GET**

[**/customer/installments**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Installments/CustomerInstallmentsController_getSchedule)

Get current balance, next due, and full schedule by circle (FR-11)

**GET**

[**/customer/installments/history**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Installments/CustomerInstallmentsController_getPaymentHistory)

Get unified payment and transaction history timeline (سجل المعاملات)

**GET**

[**/customer/installments/{id}**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Installments/CustomerInstallmentsController_getDetails)

Get single installment details, attempt history, and receipt if paid (FR-11)

**POST**

[**/customer/installments/{id}/pay**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Installments/CustomerInstallmentsController_payInstallment)

Pay due installment immediately via customer linked payment method (ادفع الآن)

**POST**

[**/customer/installments/{id}/submit-proof**](https://jameya-backend.onrender.com/api-docs#/Customer%20-%20Installments/CustomerInstallmentsController_submitProof)

Submit manual payment proof (Vodafone Cash / InstaPay) - Feature Flagged

#### Schemas

**RequestOtpDto**

**VerifyOtpDto**

**CreateFeePolicyDto**

**ActivateFeePolicyDto**

**StartJoinDto**

**AcceptContractDto**

**VerifySignatureOtpDto**

**AddressDto**

**CreateIdentityProfileDto**

**UploadDocumentDto**

**AdminLoginDto**

**ChangePasswordDto**

**CreateAdminUserDto**

**UpdateAdminStatusDto**

**UpdateAdminRoleDto**

**UpdateCustomerStatusDto**

**ReviewPaymentProofDto**

**FlagPaymentProofDto**

**HoldTransactionDto**

**CreateCircleDto**

**ActivateCircleDto**

**CancelCircleDto**

**ReleaseMembershipDto**

**MarkDefaultedDto**

**ReviewDocumentDto**

**CreateEligibilityDto**

**UploadKycFileDto**

**SubmitManualProofDto**

---

## Documentation Reconciliation

This file consolidates the previously prepared Jameya API documentation with the uploaded Phase 1 OAS/Swagger export. The merged document contains the endpoint details, request schemas, response examples, status codes, business-flow notes, and DTO/schema names available in the supplied sources.

- **Base URL:** `https://jameya-backend.onrender.com`
- **Swagger/OpenAPI UI:** `https://jameya-backend.onrender.com/api-docs`
- Example access tokens have been replaced with `<JWT_ACCESS_TOKEN>` in this consolidated copy for safety.
- No endpoint behavior has been invented or changed; details are retained from the supplied API documentation.
