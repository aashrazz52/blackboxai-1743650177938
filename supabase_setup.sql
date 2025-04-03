-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table for authentication
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login TIMESTAMPTZ
);

-- Community posts table
CREATE TABLE community_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  is_anonymous BOOLEAN DEFAULT TRUE
);

-- Journal entries table
CREATE TABLE journal_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  prompt_id INTEGER NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ
);

-- Questionnaire responses
CREATE TABLE questionnaire_responses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE SET NULL,
  score INTEGER NOT NULL,
  responses JSONB NOT NULL,
  completed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for performance
CREATE INDEX idx_community_posts_user ON community_posts(user_id);
CREATE INDEX idx_journal_entries_user ON journal_entries(user_id);
CREATE INDEX idx_journal_entries_prompt ON journal_entries(prompt_id);

-- Set up Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE journal_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE questionnaire_responses ENABLE ROW LEVEL SECURITY;

-- Users RLS Policies
CREATE POLICY "Users can view their own profile" 
ON users FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
ON users FOR UPDATE USING (auth.uid() = id);

-- Community Posts RLS Policies
CREATE POLICY "Enable read access for all users"
ON community_posts FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users"
ON community_posts FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable delete for own posts"
ON community_posts FOR DELETE USING (auth.uid() = user_id);

-- Journal Entries RLS Policies
CREATE POLICY "Enable full access to own journal entries"
ON journal_entries FOR ALL USING (auth.uid() = user_id);

-- Questionnaire Responses RLS Policies
CREATE POLICY "Enable read access to own responses"
ON questionnaire_responses FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Enable insert for authenticated users"
ON questionnaire_responses FOR INSERT WITH CHECK (auth.role() = 'authenticated');
