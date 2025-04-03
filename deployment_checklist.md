# InnerSpace Deployment Guide

## 1. Pre-Deployment Checklist
- [ ] Complete all testing scenarios
- [ ] Verify database backups are configured
- [ ] Set up monitoring (Supabase logs, Dorik analytics)
- [ ] Configure error tracking (Sentry or similar)
- [ ] Prepare rollback plan

## 2. Supabase Deployment
```bash
# 1. Apply database schema
psql -h YOUR_SUPABASE_URL -p 5432 -U postgres -d postgres -f supabase_setup.sql

# 2. Configure environment variables
export SUPABASE_URL=your-project-ref.supabase.co
export SUPABASE_KEY=your-anon-key
```

## 3. Dorik Hosting Setup
1. Go to Dorik Dashboard > Hosting
2. Select "Connect Custom Domain" (optional)
3. Set build settings:
   ```json
   {
     "buildCommand": "npm run build",
     "outputDirectory": "dist",
     "environmentVariables": {
       "VITE_SUPABASE_URL": "$SUPABASE_URL",
       "VITE_SUPABASE_KEY": "$SUPABASE_KEY"
     }
   }
   ```
4. Enable "Auto-Deploy" on Git push

## 4. Make.com Configuration
1. Create new scenario for each automation
2. Connect Supabase webhooks:
   ```javascript
   // Sample webhook configuration
   {
     "url": "https://hook.make.com/YOUR_UNIQUE_ID",
     "secret": "your-shared-secret",
     "events": ["insert", "update"]
   }
   ```
3. Test all automation flows

## 5. DNS Configuration (If using custom domain)
```dns
Record Type | Name       | Value
----------------------------------------
CNAME      | www        | dorik.io
A          | @          | 76.76.21.21
TXT        | @          | "dorik-verification=abc123"
```

## 6. Final Verification
1. Smoke test all critical paths:
   - User registration
   - Journal entry
   - Community post
   - Questionnaire
2. Verify email deliveries
3. Check real-time updates
4. Test mobile responsiveness

## 7. Post-Launch
- [ ] Set up uptime monitoring
- [ ] Configure backup schedule (daily)
- [ ] Enable Supabase logs retention (30 days)
- [ ] Schedule weekly maintenance window

## Rollback Procedure
1. Revert Dorik to previous version
2. Restore Supabase from backup:
   ```sql
   pg_restore -h YOUR_SUPABASE_URL -U postgres -d postgres backup.dump
   ```
3. Pause Make.com automations