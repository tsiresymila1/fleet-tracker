-- Create api_tokens table
CREATE TABLE IF NOT EXISTS api_tokens (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  scope VARCHAR(50) NOT NULL DEFAULT 'read' CHECK (scope IN ('read', 'read-write', 'admin')),
  last_used_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create index on token for fast lookups
CREATE INDEX IF NOT EXISTS idx_api_tokens_token ON api_tokens(token);
CREATE INDEX IF NOT EXISTS idx_api_tokens_user_id ON api_tokens(user_id);

-- Enable RLS
ALTER TABLE api_tokens ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Users can view their own tokens
CREATE POLICY "Users can view their own tokens"
  ON api_tokens
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can create their own tokens
CREATE POLICY "Users can create their own tokens"
  ON api_tokens
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own tokens (for last_used_at, name)
CREATE POLICY "Users can update their own tokens"
  ON api_tokens
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Users can delete their own tokens
CREATE POLICY "Users can delete their own tokens"
  ON api_tokens
  FOR DELETE
  USING (auth.uid() = user_id);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_api_tokens_updated_at
  BEFORE UPDATE ON api_tokens
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
