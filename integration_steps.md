# InnerSpace Final Integration Steps

## 1. Supabase-Dorik Connection
```javascript
// In Dorik project settings > Integrations:
{
  "supabase": {
    "url": "YOUR_SUPABASE_URL",
    "anonKey": "YOUR_SUPABASE_ANON_KEY",
    "tables": {
      "users": "users",
      "posts": "community_posts",
      "journals": "journal_entries",
      "responses": "questionnaire_responses"
    }
  }
}
```

## 2. Authentication Flow
```javascript
// Dorik Auth Component Configuration:
{
  "auth": {
    "provider": "supabase",
    "loginRedirect": "/dashboard",
    "logoutRedirect": "/",
    "signupFields": ["email", "password"],
    "passwordReset": {
      "enabled": true,
      "template": "reset_password"
    }
  }
}
```

## 3. Community Feed Integration
```javascript
// Community page component:
{
  "dataSource": {
    "type": "supabase",
    "query": "SELECT * FROM community_posts ORDER BY created_at DESC LIMIT 50",
    "realtime": true
  },
  "postForm": {
    "submitAction": {
      "type": "supabase",
      "table": "community_posts",
      "fields": {
        "user_id": "{{auth.user.id}}",
        "content": "{{form.content}}"
      }
    }
  }
}
```

## 4. Journaling Prompts Integration
```javascript
// Journal component:
{
  "prompts": {
    "source": "local", 
    "data": "journaling_prompts.json"
  },
  "saveAction": {
    "type": "supabase",
    "table": "journal_entries",
    "fields": {
      "user_id": "{{auth.user.id}}",
      "prompt_id": "{{selectedPrompt.id}}",
      "entry": "{{editorContent}}"
    }
  }
}
```

## 5. PHQ-9 Questionnaire Integration
```javascript
// Questionnaire component:
{
  "questions": "phq9_questionnaire.json",
  "submitAction": {
    "type": "supabase",
    "table": "questionnaire_responses",
    "fields": {
      "user_id": "{{auth.user.id}}",
      "score": "{{calculatedScore}}",
      "responses": "{{questionResponses}}"
    }
  }
}
```

## 6. Make.com Webhooks
```javascript
// Supabase Webhook Configuration:
{
  "webhooks": [
    {
      "event": "user_signup",
      "url": "YOUR_MAKE_WEBHOOK/new-user",
      "secret": "YOUR_SECRET"
    },
    {
      "event": "questionnaire_completed",
      "url": "YOUR_MAKE_WEBHOOK/phq9-submitted",
      "secret": "YOUR_SECRET"
    }
  ]
}
```

## 7. Final Checks
1. Verify all Supabase RLS policies are active
2. Test authentication flow (signup/login/logout)
3. Validate real-time community updates
4. Check journal entry persistence
5. Test questionnaire scoring logic
6. Verify email notifications via Make.com