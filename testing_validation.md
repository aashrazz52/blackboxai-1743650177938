# InnerSpace Testing Scenarios

## 1. Authentication Flow
```gherkin
Scenario: Successful user registration
  Given I am on the signup page
  When I enter valid email and password
  And click "Create Account"
  Then I should receive welcome email
  And be redirected to dashboard
  And my account should exist in Supabase users table

Scenario: Failed login
  Given I am on the login page
  When I enter invalid credentials
  Then I should see "Invalid login" error
  And not be authenticated
```

## 2. Community Features
```gherkin
Scenario: Anonymous posting
  Given I am logged in
  When I create a community post
  Then it should appear in the feed
  And show as "Anonymous" to others
  But show as mine in my view

Scenario: Real-time updates
  Given two logged-in users
  When UserA posts in community
  Then UserB should see the post appear without refresh
```

## 3. Journaling Functionality
```gherkin
Scenario: Prompt selection
  Given I am logged in
  When I select a journaling prompt
  Then I should see a writing interface
  With the prompt displayed
  And word count visible

Scenario: Entry persistence
  Given I have written a journal entry
  When I save it
  Then it should appear in my journal history
  And be stored in Supabase
```

## 4. PHQ-9 Questionnaire
```gherkin
Scenario: Score calculation
  Given I answer all PHQ-9 questions
  When I submit with total score 12
  Then I should see "Moderate depression" result
  With appropriate resources

Scenario: Critical response
  Given I answer Q9 with "Nearly every day"
  When I submit
  Then I should see crisis resources prominently
  And admin should be notified
```

## 5. Email Notifications
```gherkin
Scenario: Weekly digest
  Given it's Friday 5PM
  And I'm an active user
  Then I should receive weekly digest email
  With community highlights
  And new prompts

Scenario: Inactivity reminder
  Given I haven't logged in for 7 days
  When the daily job runs
  Then I should receive a check-in email
```

## Validation Checklist
1. [ ] All pages render correctly on mobile/desktop
2. [ ] Authentication flows work (signup/login/logout/reset)
3. [ ] Community posts appear in real-time
4. [ ] Journal entries save and load properly
5. [ ] PHQ-9 calculates scores correctly
6. [ ] Critical responses trigger alerts
7. [ ] All animations work smoothly
8. [ ] Emails are delivered and formatted correctly
9. [ ] Data persists after refresh
10. [ ] All links navigate correctly