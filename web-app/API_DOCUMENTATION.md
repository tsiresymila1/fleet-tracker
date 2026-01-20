# Fleet Tracker API Documentation

## Secure API Gateway

The Secure API Gateway allows third-party systems to integrate with your fleet tracking data programmatically using API tokens.

## Getting Started

### 1. Create an API Token

1. Log into your dashboard
2. Navigate to the Dashboard page
3. Scroll to the "Integration Relay" section
4. Click "Create API Token"
5. Enter a descriptive name (e.g., "Production API", "Warehouse System")
6. Select a scope:
   - **Read Only**: Can only read fleet data
   - **Read & Write**: Can read and update device information
   - **Admin**: Full access (future use)
7. Copy the token immediately - it's only shown once!

### 2. Using Your Token

Include your token in the `Authorization` header of all API requests:

```
Authorization: Bearer ft_your_token_here
```

## API Endpoints

Base URL: `https://your-domain.com/api/v1`

### Devices

#### Get All Devices
```http
GET /api/v1/devices
Authorization: Bearer ft_your_token_here
```

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "device_id": "DEVICE001",
      "device_name": "Fleet Vehicle 1",
      "is_enabled": true,
      "last_seen_at": "2024-01-15T10:30:00Z",
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

#### Get Specific Device
```http
GET /api/v1/devices/{deviceId}
Authorization: Bearer ft_your_token_here
```

#### Update Device (requires read-write scope)
```http
PATCH /api/v1/devices/{deviceId}
Authorization: Bearer ft_your_token_here
Content-Type: application/json

{
  "device_name": "Updated Name",
  "is_enabled": true
}
```

### Positions

#### Get Positions
```http
GET /api/v1/positions?device_id={id}&start_date={date}&end_date={date}&limit={number}
Authorization: Bearer ft_your_token_here
```

**Query Parameters:**
- `device_id` (optional): Filter by specific device
- `start_date` (optional): ISO 8601 date string
- `end_date` (optional): ISO 8601 date string
- `limit` (optional): Number of records (default: 100, max: 1000)

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "latitude": 48.8566,
      "longitude": 2.3522,
      "speed": 60.5,
      "heading": 90,
      "altitude": 150,
      "status": "moving",
      "recorded_at": "2024-01-15T10:30:00Z",
      "devices": {
        "device_id": "DEVICE001",
        "device_name": "Fleet Vehicle 1",
        "user_id": "user-uuid"
      }
    }
  ]
}
```

#### Get Latest Positions
```http
GET /api/v1/positions/latest
Authorization: Bearer ft_your_token_here
```

**Response:**
```json
{
  "data": [
    {
      "device_id": "DEVICE001",
      "device_name": "Fleet Vehicle 1",
      "position": {
        "latitude": 48.8566,
        "longitude": 2.3522,
        "speed": 60.5,
        "heading": 90,
        "altitude": 150,
        "status": "moving",
        "recorded_at": "2024-01-15T10:30:00Z"
      }
    }
  ]
}
```

## Examples

### cURL
```bash
curl -X GET "https://your-domain.com/api/v1/devices" \
  -H "Authorization: Bearer ft_your_token_here"
```

### JavaScript/TypeScript
```javascript
const response = await fetch('https://your-domain.com/api/v1/positions?limit=50', {
  headers: {
    'Authorization': `Bearer ${apiToken}`,
    'Content-Type': 'application/json'
  }
});

const data = await response.json();
console.log(data.data);
```

### Python
```python
import requests

headers = {
    'Authorization': f'Bearer {api_token}',
    'Content-Type': 'application/json'
}

response = requests.get('https://your-domain.com/api/v1/devices', headers=headers)
data = response.json()
print(data['data'])
```

## Error Responses

All errors follow this format:

```json
{
  "error": "Error message here"
}
```

**Status Codes:**
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized (invalid or missing token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `500` - Internal Server Error

## Token Management

### View Your Tokens
Tokens can be viewed, copied, and deleted from the Dashboard → Integration Relay section.

### Security Best Practices

1. **Never commit tokens to version control**
2. **Store tokens securely** (environment variables, secret managers)
3. **Use different tokens for different environments** (dev, staging, production)
4. **Rotate tokens regularly**
5. **Delete unused tokens immediately**
6. **Use the minimum required scope** (start with "read" if possible)

## Database Migration

To set up the API tokens table, run the migration:

```sql
-- Run the migration file in your Supabase SQL editor:
-- server/supabase/migrations/create_api_tokens.sql
```

Or apply it via Supabase CLI:
```bash
supabase db push
```

## Rate Limiting

Currently, there are no rate limits, but please use the API responsibly. Rate limiting may be added in future versions.
