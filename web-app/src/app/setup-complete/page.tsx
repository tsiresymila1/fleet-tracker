import Link from 'next/link';
import { Truck, ArrowLeft, CheckCircle2, Code2, AlertCircle, Terminal, FileText } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

export const metadata = {
  title: 'API Documentation - FleetTrack',
  description: 'Fleet Tracker API documentation for integrating with your fleet tracking system.',
};

export default function SetupCompletePage() {
  return (
    <div className="min-h-screen bg-black text-white font-outfit">
      {/* Navbar */}
      <header className="px-4 lg:px-6 h-20 flex items-center border-b border-white/10 sticky top-0 bg-black/50 backdrop-blur-md z-50">
        <Link className="flex items-center gap-2" href="/">
          <ArrowLeft className="h-5 w-5" />
          <span className="text-sm font-medium">Back</span>
        </Link>
        <div className="ml-auto flex items-center gap-2">
          <div className="bg-primary p-2 rounded-lg">
            <Truck className="h-6 w-6 text-white" />
          </div>
          <span className="font-bold text-xl">FleetTrack</span>
        </div>
      </header>

      <main className="flex-1">
        {/* Header Section */}
        <section className="w-full py-12 px-4 border-b border-white/10">
          <div className="max-w-4xl mx-auto">
            <div className="flex items-center gap-3 mb-4">
              <Code2 className="h-8 w-8 text-blue-500" />
              <h1 className="text-4xl font-bold">Fleet Tracker API Documentation</h1>
            </div>
            <p className="text-zinc-400 text-lg">
              Integrate with your fleet tracking data using our secure API gateway.
            </p>
          </div>
        </section>

        {/* Content */}
        <section className="w-full py-12 px-4">
          <div className="max-w-4xl mx-auto space-y-8">
            {/* Getting Started */}
            <Card className="border-border bg-card/50">
              <CardHeader>
                <CardTitle className="text-2xl">Getting Started</CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                <div>
                  <h3 className="font-semibold mb-3 text-lg">1. Create an API Token</h3>
                  <ol className="text-sm text-zinc-400 space-y-2 list-decimal list-inside">
                    <li>{'Log into your dashboard'}</li>
                    <li>Navigate to the Dashboard page</li>
                    <li>{'Scroll to the "Integration Relay" section'}</li>
                    <li>{'Click "Create API Token"'}</li>
                    <li>{'Enter a descriptive name (e.g., "Production API", "Warehouse System")'}</li>
                    <li>Select a scope:
                      <ul className="list-disc list-inside mt-2 ml-4 space-y-1">
                        <li><strong>Read Only</strong>: Can only read fleet data</li>
                        <li><strong>Read & Write</strong>: Can read and update device information</li>
                        <li><strong>Admin</strong>: Full access (future use)</li>
                      </ul>
                    </li>
                    <li>Copy the token immediately - it&apos;s only shown once!</li>
                  </ol>
                </div>

                <div>
                  <h3 className="font-semibold mb-3 text-lg">2. Using Your Token</h3>
                  <p className="text-sm text-zinc-400 mb-2">
                    Include your token in the `Authorization` header of all API requests:
                  </p>
                  <div className="bg-zinc-950 border border-zinc-800 rounded-lg p-4 overflow-x-auto">
                    <code className="text-xs text-zinc-300 font-mono">
                      Authorization: Bearer ft_your_token_here
                    </code>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* API Endpoints */}
            <Card className="border-border bg-card/50">
              <CardHeader>
                <CardTitle className="text-2xl">API Endpoints</CardTitle>
                <p className="text-sm text-muted-foreground mt-2">
                  Base URL: <code className="bg-zinc-950 px-2 py-1 rounded text-xs">https://your-domain.com/api/v1</code>
                </p>
              </CardHeader>
              <CardContent className="space-y-6">
                {/* Devices Section */}
                <div>
                  <h3 className="font-semibold mb-4 text-lg">Devices</h3>
                  <div className="space-y-4">
                    <div className="border border-zinc-800 rounded-lg p-4">
                      <div className="flex items-center gap-2 mb-3">
                        <span className="bg-blue-900 text-blue-200 text-xs font-mono px-2 py-1 rounded">GET</span>
                        <code className="text-sm text-zinc-300">/api/v1/devices</code>
                      </div>
                      <p className="text-sm text-zinc-400 mb-3">Get all devices</p>
                      <div className="bg-zinc-950 border border-zinc-800 rounded p-3 overflow-x-auto">
                        <code className="text-xs text-zinc-300 font-mono">
                          Authorization: Bearer ft_your_token_here
                        </code>
                      </div>
                    </div>

                    <div className="border border-zinc-800 rounded-lg p-4">
                      <div className="flex items-center gap-2 mb-3">
                        <span className="bg-blue-900 text-blue-200 text-xs font-mono px-2 py-1 rounded">GET</span>
                        <code className="text-sm text-zinc-300">/api/v1/devices/&#123;deviceId&#125;</code>
                      </div>
                      <p className="text-sm text-zinc-400">Get specific device</p>
                    </div>

                    <div className="border border-zinc-800 rounded-lg p-4">
                      <div className="flex items-center gap-2 mb-3">
                        <span className="bg-purple-900 text-purple-200 text-xs font-mono px-2 py-1 rounded">PATCH</span>
                        <code className="text-sm text-zinc-300">/api/v1/devices/&#123;deviceId&#125;</code>
                      </div>
                      <p className="text-sm text-zinc-400 mb-3">Update device (requires read-write scope)</p>
                      <div className="bg-zinc-950 border border-zinc-800 rounded p-3 overflow-x-auto">
                        <code className="text-xs text-zinc-300 font-mono">
{`{
  "device_name": "Updated Name",
  "is_enabled": true
}`}
                        </code>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Positions Section */}
                <div>
                  <h3 className="font-semibold mb-4 text-lg">Positions</h3>
                  <div className="space-y-4">
                    <div className="border border-zinc-800 rounded-lg p-4">
                      <div className="flex items-center gap-2 mb-3">
                        <span className="bg-blue-900 text-blue-200 text-xs font-mono px-2 py-1 rounded">GET</span>
                        <code className="text-sm text-zinc-300">/api/v1/positions</code>
                      </div>
                      <p className="text-sm text-zinc-400 mb-3">Get positions with optional filters</p>
                      <div className="text-sm text-zinc-400 mb-3">
                        <strong>Query Parameters:</strong>
                        <ul className="list-disc list-inside mt-2 space-y-1">
                          <li><code className="bg-zinc-950 px-1 rounded text-xs">device_id</code> (optional): Filter by specific device</li>
                          <li><code className="bg-zinc-950 px-1 rounded text-xs">start_date</code> (optional): ISO 8601 date string</li>
                          <li><code className="bg-zinc-950 px-1 rounded text-xs">end_date</code> (optional): ISO 8601 date string</li>
                          <li><code className="bg-zinc-950 px-1 rounded text-xs">limit</code> (optional): Number of records (default: 100, max: 1000)</li>
                        </ul>
                      </div>
                    </div>

                    <div className="border border-zinc-800 rounded-lg p-4">
                      <div className="flex items-center gap-2 mb-3">
                        <span className="bg-blue-900 text-blue-200 text-xs font-mono px-2 py-1 rounded">GET</span>
                        <code className="text-sm text-zinc-300">/api/v1/positions/latest</code>
                      </div>
                      <p className="text-sm text-zinc-400">Get latest positions for all devices</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Code Examples */}
            <Card className="border-border bg-card/50">
              <CardHeader>
                <CardTitle className="text-2xl">Code Examples</CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                <div>
                  <h3 className="font-semibold mb-3">cURL</h3>
                  <div className="bg-zinc-950 border border-zinc-800 rounded-lg p-4 overflow-x-auto">
                    <code className="text-xs text-zinc-300 font-mono">
{`curl -X GET "https://your-domain.com/api/v1/devices" \\
  -H "Authorization: Bearer ft_your_token_here"`}
                    </code>
                  </div>
                </div>

                <div>
                  <h3 className="font-semibold mb-3">JavaScript/TypeScript</h3>
                  <div className="bg-zinc-950 border border-zinc-800 rounded-lg p-4 overflow-x-auto">
                    <code className="text-xs text-zinc-300 font-mono">
{`const response = await fetch(
  'https://your-domain.com/api/v1/positions?limit=50',
  {
    headers: {
      'Authorization': \`Bearer \${apiToken}\`,
      'Content-Type': 'application/json'
    }
  }
);

const data = await response.json();
console.log(data.data);`}
                    </code>
                  </div>
                </div>

                <div>
                  <h3 className="font-semibold mb-3">Python</h3>
                  <div className="bg-zinc-950 border border-zinc-800 rounded-lg p-4 overflow-x-auto">
                    <code className="text-xs text-zinc-300 font-mono">
{`import requests

headers = {
    'Authorization': f'Bearer {api_token}',
    'Content-Type': 'application/json'
}

response = requests.get(
    'https://your-domain.com/api/v1/devices',
    headers=headers
)
data = response.json()
print(data['data'])`}
                    </code>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Error Responses */}
            <Card className="border-border bg-card/50">
              <CardHeader>
                <CardTitle className="text-2xl">Error Responses</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-sm text-zinc-400 mb-3">All errors follow this format:</p>
                <div className="bg-zinc-950 border border-zinc-800 rounded-lg p-4 mb-4 overflow-x-auto">
                  <code className="text-xs text-zinc-300 font-mono">
{`{
  "error": "Error message here"
}`}
                  </code>
                </div>

                <div>
                  <p className="text-sm font-semibold mb-3">Status Codes:</p>
                  <div className="space-y-2">
                    {[
                      { code: 200, msg: 'Success' },
                      { code: 201, msg: 'Created' },
                      { code: 400, msg: 'Bad Request' },
                      { code: 401, msg: 'Unauthorized (invalid or missing token)' },
                      { code: 403, msg: 'Forbidden (insufficient permissions)' },
                      { code: 404, msg: 'Not Found' },
                      { code: 500, msg: 'Internal Server Error' },
                    ].map((item, idx) => (
                      <div key={idx} className="text-sm text-zinc-400">
                        <code className="bg-zinc-950 px-2 py-1 rounded text-xs font-mono">{item.code}</code>
                        <span className="ml-2">- {item.msg}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Security Best Practices */}
            <Card className="border-blue-900/50 bg-blue-950/20">
              <CardHeader>
                <CardTitle className="text-2xl text-blue-400">Security Best Practices</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {[
                    'Never commit tokens to version control',
                    'Store tokens securely (environment variables, secret managers)',
                    'Use different tokens for different environments (dev, staging, production)',
                    'Rotate tokens regularly',
                    'Delete unused tokens immediately',
                    'Use the minimum required scope (start with "read" if possible)',
                  ].map((practice, idx) => (
                    <div key={idx} className="flex items-start gap-2">
                      <CheckCircle2 className="h-5 w-5 text-blue-400 mt-0.5 flex-shrink-0" />
                      <span className="text-sm text-blue-200">{practice}</span>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Token Management */}
            <Card className="border-border bg-card/50">
              <CardHeader>
                <CardTitle className="text-2xl">Token Management</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <h3 className="font-semibold mb-2">View Your Tokens</h3>
                  <p className="text-sm text-zinc-400">
                    Tokens can be viewed, copied, and deleted from the Dashboard → Integration Relay section.
                  </p>
                </div>

                <div className="pt-4 border-t border-zinc-800">
                  <h3 className="font-semibold mb-2">Rate Limiting</h3>
                  <p className="text-sm text-zinc-400">
                    Currently, there are no rate limits, but please use the API responsibly. Rate limiting may be added in future versions.
                  </p>
                </div>
              </CardContent>
            </Card>
          </div>
        </section>

        {/* Footer */}
        <section className="w-full py-12 px-4 border-t border-white/10 mt-8">
          <div className="max-w-4xl mx-auto flex justify-center">
            <Link href="/">
              <Button className="bg-primary hover:bg-primary/90 text-primary-foreground px-8 rounded-md">
                Back to Home
              </Button>
            </Link>
          </div>
        </section>
      </main>
    </div>
  );
}
