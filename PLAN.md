# School Management System — Implementation Plan

## Overview
Build a complete School Management System (Campus One) with three role levels:
- **Super Admin**: Manages schools, subscription plans, school admins, and global reports
- **School Admin**: Manages teachers, students, classes, sections, subjects, attendance, fees
- **Teachers/Students**: Managed via the admin panels (no separate login for this MVP)

## Gems to Add
- `bcrypt` — password hashing for users
- `prawn` + `prawn-table` — PDF receipts and ID cards
- `pagy` — pagination for lists

## Database Design

### Core Auth & Multi-tenancy
- **users** — `id`, `email`, `password_digest`, `role` (`super_admin` | `school_admin`), `school_id` (nullable for super admin), `name`, `status`, timestamps
- **schools** — `id`, `name`, `email`, `phone`, `address`, `status` (`active` | `inactive`), `subscription_expiry`, `subscription_plan_id`, timestamps
- **subscription_plans** — `id`, `name`, `price`, `duration_months`, `features` (JSON), `status`, timestamps

### Academic Structure
- **classrooms** — `id`, `school_id`, `name`, `status`, timestamps
- **sections** — `id`, `school_id`, `classroom_id`, `name`, `status`, timestamps
- **subjects** — `id`, `school_id`, `name`, `code`, `status`, timestamps
- **classroom_subjects** — `id`, `classroom_id`, `subject_id`, `teacher_id` (join table for class-subject-teacher assignment), timestamps

### People
- **students** — `id`, `school_id`, `classroom_id`, `section_id`, `name`, `roll_no`, `father_name`, `mother_name`, `guardian_name`, `mobile`, `email`, `address`, `date_of_birth`, `gender`, `admission_date`, `photo`, `status`, timestamps
- **teachers** — `id`, `school_id`, `name`, `email`, `mobile`, `qualification`, `address`, `salary`, `joining_date`, `photo`, `status`, timestamps

### Attendance
- **student_attendances** — `id`, `student_id`, `classroom_id`, `date`, `status` (`present` | `absent` | `leave`), `remarks`, timestamps
- **teacher_attendances** — `id`, `teacher_id`, `date`, `status` (`present` | `absent` | `leave`), `remarks`, timestamps

### Fee Management
- **fee_structures** — `id`, `school_id`, `classroom_id`, `name` (e.g., "Monthly Tuition"), `amount`, `frequency` (`monthly` | `quarterly` | `yearly` | `one_time`), `status`, timestamps
- **fee_collections** — `id`, `student_id`, `fee_structure_id`, `amount`, `paid_date`, `due_date`, `status` (`paid` | `unpaid` | `partial`), `payment_mode`, `receipt_no`, timestamps

## Authentication & Authorization Strategy
1. `ApplicationController` sets `current_user` from session.
2. `require_login` — redirect to login if not authenticated.
3. `require_super_admin` / `require_school_admin` — role guards.
4. `SchoolScope` concern — scope all School Admin queries to `current_user.school_id`.
5. Login page at `/login` — session-based auth (simple, no JWT needed).

## Controllers & Views

### Public
- `SessionsController#new/create/destroy` — login/logout

### Super Admin Namespace (`/super_admin`)
- `SuperAdmin::DashboardController` — overview with school counts, revenue, expiring subscriptions
- `SuperAdmin::SchoolsController` — CRUD + toggle status
- `SuperAdmin::SubscriptionPlansController` — CRUD
- `SuperAdmin::SchoolAdminsController` — create/manage school admins (users with role `school_admin` linked to a school)
- `SuperAdmin::ReportsController` — global reports (schools by status, revenue, subscription expiry)

### School Admin Namespace (`/school_admin`)
- `SchoolAdmin::DashboardController` — school overview stats
- `SchoolAdmin::TeachersController` — CRUD + profile view
- `SchoolAdmin::StudentsController` — CRUD + admission form, assign class/section, ID card preview/PDF
- `SchoolAdmin::ClassroomsController` — CRUD
- `SchoolAdmin::SectionsController` — CRUD (nested under classrooms in UI)
- `SchoolAdmin::SubjectsController` — CRUD + assignment to teachers/classrooms
- `SchoolAdmin::StudentAttendancesController` — mark attendance, monthly report
- `SchoolAdmin::TeacherAttendancesController` — mark attendance, monthly report
- `SchoolAdmin::FeeStructuresController` — CRUD
- `SchoolAdmin::FeeCollectionsController` — collect fee, view dues, generate receipt PDF

## Routes Structure
```ruby
root "sessions#new"
get "login", to: "sessions#new"
post "login", to: "sessions#create"
delete "logout", to: "sessions#destroy"

namespace :super_admin do
  root "dashboard#index"
  resources :schools
  resources :subscription_plans
  resources :school_admins
  resources :reports, only: [:index]
end

namespace :school_admin do
  root "dashboard#index"
  resources :classrooms
  resources :sections
  resources :subjects
  resources :teachers
  resources :students do
    member do
      get :id_card
      get :download_id_card
    end
  end
  resources :student_attendances, only: [:index, :new, :create] do
    collection do
      get :monthly_report
    end
  end
  resources :teacher_attendances, only: [:index, :new, :create] do
    collection do
      get :monthly_report
    end
  end
  resources :fee_structures
  resources :fee_collections, only: [:index, :new, :create, :show] do
    collection do
      get :due_fees
    end
    member do
      get :receipt
    end
  end
end
```

## UI/UX
- Single layout with sidebar navigation that adapts based on `current_user.role`.
- Use Turbo for fast interactions and Stimulus for small JS needs (e.g., attendance check-all).
- Propshaft + a simple custom CSS framework (no external UI library to keep it lightweight).
- Clean, modern dashboard cards and data tables.

## PDF Generation
- `Prawn` for:
  - Fee receipt (`FeeCollectionsController#receipt`)
  - Student ID card (`StudentsController#download_id_card`)

## Implementation Order (Phases)
1. **Setup**: Add gems, create migrations, run `db:migrate`.
2. **Auth**: Users model, sessions, login page, base layout with sidebar.
3. **Super Admin Core**: Schools, subscription plans, school admins, dashboard.
4. **Academic Structure**: Classrooms, sections, subjects (School Admin).
5. **People**: Teachers, students with admission flow, roll numbers.
6. **Attendance**: Student & teacher attendance + monthly reports.
7. **Fees**: Fee structures, collections, due fees, receipt PDF.
8. **Reports & Polish**: Global reports, ID card PDF, final UI touches, seeds.

## Seed Data
- 1 super admin: `admin@campus.one` / `password`
- 2 schools with school admins
- Sample classrooms, sections, subjects, teachers, students per school
- Sample attendance and fee data

## Key Decisions
- **No ActiveAdmin**: Custom controllers for full control and consistent UI.
- **No Devise**: `has_secure_password` + sessions keeps dependencies minimal and code transparent.
- **No CanCanCan**: Simple controller-level guards (`before_action`) are enough for two roles.
- **Single-table users**: Both super_admin and school_admin in `users` with `role` enum; school_id scoped for school_admin.
