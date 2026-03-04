<div align="center">
  <img src="public/banner.png" alt="ArcadeLearn Banner" width="100%">
  
  <h1>
    <img src="public/logo-bgfree.png" alt="Logo" height="40" align="center"/>
    ArcadeLearn
  </h1>
  
  <p><strong>Transform Your Tech Career Through Gamified Learning</strong></p>
  
  [![Live Demo](https://img.shields.io/badge/🚀_Live_Demo-Visit_Now-brightgreen?style=for-the-badge)](https://arcade-learn-gqp0.onrender.com/)
  [![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](https://reactjs.org/)
  [![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)
  [![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)
  [![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com/)
  [![Render](https://img.shields.io/badge/Render-Deployed-46E3B7?style=for-the-badge&logo=render&logoColor=white)](https://render.com/)
  
  <p><em>Your personalized journey from beginner to industry-ready professional</em></p>
  
  [Features](#-core-features) • [How It Works](#-how-it-works) • [Tech Stack](#️-technology-stack) • [Getting Started](#-quick-start) • [Roadmap](#-roadmap)
  
</div>


# ArcadeLearn Project Context for Gemini CLI

This document provides a comprehensive overview of the ArcadeLearn project, intended to serve as instructional context for interactions with the Gemini CLI agent.

## Project Overview

ArcadeLearn is a gamified learning platform designed to transform tech careers. It addresses common learning challenges such as information overload, lack of clear guidance, and low motivation by offering structured roadmaps, gamification elements, career matching, community support, and analytics. The platform aims to guide users from beginners to industry-ready professionals through a personalized learning journey.

**Key Features:**
*   Smart Learning Roadmaps (15+ career paths, 200+ components, curated resources)
*   Gamification Engine (XP, stars, achievements, streaks, leaderboards)
*   Career Intelligence (AI-powered roadmaps via Google Gemini AI, job matching, salary insights, resume builder)
*   Community & Support (live doubt sessions, peer discussions, mentor guidance)
*   Analytics & Insights (personal dashboard, progress visualization)

**Architecture:**
The project is a full-stack application. The frontend is a React application, and there is a separate Node.js backend API. Supabase is utilized for backend services, including authentication and database management (PostgreSQL).

## Technology Stack

*   **Frontend:** React 18, TypeScript, Tailwind CSS, Vite (build tool), shadcn/ui, Lucide React, React Context + TanStack Query
*   **Backend:** Node.js (Backend API), Supabase (Backend & Auth, PostgreSQL)
*   **AI Features:** Google Gemini AI
*   **Other Services:** EmailJS (notifications), Adzuna & RemoteOK (Job APIs), @react-pdf/renderer (PDF Generation)
*   **Deployment:** Render (Full Stack)

## Building and Running the Project

### Prerequisites

*   Node.js 18+ (with npm)
*   Git
*   Supabase account (free tier works)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/VickyKumarOfficial/Arcade-Learn.git
    cd Arcade-Learn
    ```

2.  **Install frontend dependencies:**
    ```bash
    npm install
    ```

3.  **Set up frontend environment variables:**
    Copy the example environment file and edit it with your credentials.
    ```bash
    cp .env.example .env.local
    ```
    *   `VITE_SUPABASE_URL`
    *   `VITE_SUPABASE_ANON_KEY`
    *   `VITE_EMAILJS_SERVICE_ID` (optional)
    *   `VITE_EMAILJS_TEMPLATE_ID` (optional)
    *   `VITE_EMAILJS_PUBLIC_KEY` (optional)
    *   `VITE_GEMINI_API_KEY` (optional)

4.  **Start frontend development server:**
    ```bash
    npm run dev
    ```

### Backend Setup

1.  **Navigate to the backend directory:**
    ```bash
    cd backend
    ```

2.  **Install backend dependencies:**
    ```bash
    npm install
    ```

3.  **Set up backend environment variables:**
    Copy the example environment file and edit it with your credentials.
    ```bash
    cp .env.example .env
    ```
    *   (Refer to `backend/.env.example` for specific variables)

4.  **Start backend development server:**
    ```bash
    npm run dev
    ```

### Database Setup

1.  Go to [Supabase Dashboard](https://app.supabase.com).
2.  Create a new project.
3.  Run the SQL schema located in `database/schema.sql` (not explicitly read, but inferred from README).
4.  Enable Row Level Security (RLS) policies.

## Development Conventions

*   **Code Quality:** Emphasizes clean, documented code.
*   **Code Style:** Follow existing code style.
*   **Testing:** Add tests where applicable.
*   **Commit Messages:** Use clear commit messages.
*   **Best Practices:** Follow TypeScript & React best practices.
*   **Documentation:** Update documentation when making changes.
*   **Collaboration:** Be respectful and collaborative in contributions.

## Further Exploration (TODO)

*   Explore the `database/schema.sql` file for database structure details.
*   Examine the `backend` directory for specific API endpoints and logic.
*   Review `package.json` files (root and `backend`) for full script details.
