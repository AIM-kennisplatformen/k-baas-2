# [TASK] T2.1.1: User Model & Database Schema

**Issue Type:** Task  
**Parent Story:** S2.1 User Registration System  
**Epic:** E2 Authentication & User Management  
**Milestone:** M2  
**Status:** Open  
**Assigned:** Developer 1 (Backend lead)  

## 📋 Labels
- `epic:E2-authentication`
- `type:task`
- `priority:P1-high`
- `size:M`
- `version:v0.7`
- `team:backend`

## 🔧 Task Description
Create user data model and TypeDB schema for user accounts and authentication.

## 📊 Task Details
**Estimated Effort:** 1 day  
**Priority:** P1-High  
**Dependencies:** Blocked by M1 (Foundation infrastructure)

## 📋 Task Acceptance Criteria
- [ ] User Pydantic model with email, password, first name, last name
- [ ] TypeDB schema for user entities
- [ ] Password hashing and validation
- [ ] Email format validation
- [ ] User unique constraints (email)
- [ ] User schema migration scripts

## 🔧 Implementation Steps
1. Create User Pydantic model
2. Define TypeDB user entity schema
3. Implement password hashing
4. Add email validation
5. Setup unique constraints
6. Create migration scripts

## ✅ Definition of Done
- [ ] User model properly defined with validation
- [ ] TypeDB schema supports user storage
- [ ] Password security meets requirements
- [ ] Email validation prevents invalid addresses
- [ ] Unique constraints prevent duplicate users

## 🔗 Dependencies
**Blocks:** T2.1.2 (Registration API), T2.1.3 (Security)  
**Blocked by:** M1 (Foundation & Infrastructure) 