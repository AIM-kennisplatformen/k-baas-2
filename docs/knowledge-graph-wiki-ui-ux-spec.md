# Knowledge Graph Wiki Tool UI/UX Specification

## Introduction

This document defines the user experience goals, information architecture, user flows, and visual design specifications for the Knowledge Graph Wiki Tool's user interface. The tool aims to create an intuitive, collaborative platform that empowers domain experts to build, visualize, and share interconnected knowledge without requiring technical expertise.

- **Link to Primary Design Files:** [To be created in Figma]
- **Link to Deployed Storybook / Design System:** [To be implemented]

## Overall UX Goals & Principles

- **Target User Personas:** 
  - Domain experts with specialized knowledge but limited technical expertise
  - Professionals who need to document, organize, and share complex information within their fields
  - Collaborative teams where knowledge sharing is essential
  - Users who value intuitive interfaces, visual representations of relationships, and tools that help them focus on content rather than technical implementation

- **Usability Goals:** 
  - Minimize learning curve for non-technical domain experts
  - Enable efficient creation and editing of both wiki content and knowledge graph elements
  - Provide clear visual feedback for user actions
  - Support real-time collaboration with minimal friction
  - Ensure accessibility for users with different abilities
  - Maintain consistency between wiki and graph representations
  - Provide immediate feedback with automatic saving

- **Design Principles:** 
  - **User-Centricity Above All:** Always champion the user's needs. Ensure usability, accessibility, and a delightful, intuitive experience are at the forefront of all design decisions.
  - **Clarity Over Cleverness:** Prioritize clear, straightforward interfaces over novel but potentially confusing interactions.
  - **Consistency & Predictability:** Maintain consistent patterns throughout the interface to build user confidence and reduce cognitive load.
  - **Direct Manipulation:** Allow users to interact directly with visual elements rather than through abstract controls whenever possible.
  - **Progressive Disclosure:** Present only the most necessary options initially, revealing more advanced features as needed.

## Information Architecture (IA)

- **Site Map / Screen Inventory:**
  ```mermaid
  graph TD
    A[Login/Registration] --> B[Main Editor View];
    A --> C[User/Team Management];
    A --> D[Settings & Configuration];
    B --> E[Wiki Editor Mode];
    B --> F[Graph Visualization Mode];
    B --> G[Split View Mode];
    B --> H[To-Do List View];
    B --> I[Document Upload & Processing];
    B --> J[Publishing View];
    B --> K[Version History View];
    C --> L[User Profile];
    C --> M[Team Management];
    C --> N[Permissions Management];
    D --> O[User Preferences];
    D --> P[System Settings];
    E --> Q[Wiki Page Editor];
    E --> R[Media Browser];
    F --> S[Graph Explorer];
    H --> T[Completeness Dashboard];
    J --> U[Published View Configuration];
    J --> V[Access Control Settings];
    K --> W[Timeline View];
    K --> X[Diff Comparison];
  ```

- **Navigation Structure:** 
  - **Primary Navigation:** Left sidebar with logo, user menu, view toggles, and knowledge base selector (if user has access to multiple KBs)
  - **Context Panels:** Popovers and inline panels that appear when interacting with elements, showing properties, comments, and metadata
  - **View Switching:** Tabs or toggle buttons in the left sidebar to switch between wiki, graph, split, to-do list, and other views

## User Flows

### User Login & Knowledge Base Access

- **Goal:** User wants to access their knowledge base to start working.
- **Steps / Diagram:**
  ```mermaid
  graph TD
    Start --> Login[Enter Credentials];
    Login --> Auth{Authentication OK?};
    Auth -- Yes --> CheckKB{Multiple KBs?};
    Auth -- No --> ErrorMsg[Show Error Message];
    ErrorMsg --> Login;
    CheckKB -- Yes --> LastUsed[Open Last Used KB];
    CheckKB -- No --> SingleKB[Open User's KB];
    LastUsed --> MainEditor[Main Editor View];
    SingleKB --> MainEditor;
  ```

### Creating a New Entity (UFC)

- **Goal:** User wants to add a new entity to the knowledge graph.
- **Steps / Diagram:**
  ```mermaid
  graph TD
    Start --> Method{Creation Method};
    Method -- "Via Wiki Editor" --> WikiLink["Create Wiki-Link with double brackets syntax"];
    Method -- "Via Graph View" --> DoubleClick["Double-Click on Canvas"];
    WikiLink --> CreateUFC["Create Unidentified Flying Concept (UFC)"];
    DoubleClick --> CreateUFC;
    CreateUFC --> EditName["Edit Entity Name"];
    EditName --> AutoSave["Changes Saved Automatically"];
    AutoSave --> UFCCreated["UFC Added to Graph (Marked as Unfinished)"];
    UFCCreated --> ToDoList["Entity Appears in To-Do List"];
  ```

### Creating a Relationship Between Entities

- **Goal:** User wants to connect two entities with a relationship.
- **Steps / Diagram:**
  ```mermaid
  graph TD
    Start --> Method{Creation Method};
    Method -- "Via Graph View" --> SelectSource[Select Source Entity];
    Method -- "Via Wiki Editor" --> UseWikiLink["Use Special Wiki-Link Syntax to Connect Entities"];
    SelectSource --> DragToTarget[Drag Connection Handle to Target Entity];
    DragToTarget --> CreateRelation["Create Relationship (Type Optional)"];
    UseWikiLink --> CreateRelation;
    CreateRelation --> AutoSave["Changes Saved Automatically"];
    AutoSave --> InferType["System Attempts to Infer Relationship Type"];
    InferType --> CheckComplete{Type & Required Props Complete?};
    CheckComplete -- "Missing/Unspecified" --> MarkUnfinished["Mark as Unfinished"];
    CheckComplete -- "Complete" --> Done["Relationship Complete"];
    MarkUnfinished --> ToDoList["Relation Appears in To-Do List"];
  ```


### Collaborative Editing

- **Goal:** Multiple users want to edit the knowledge base simultaneously.
- **Steps / Diagram:**
  ```mermaid
  graph TD
    Start --> Join[User Joins Editing Session];
    Join --> Presence[System Shows User Presence Indicators];
    Presence --> Edit{Edit Actions};
    Edit -- "Make Changes" --> UserEdits[User Makes Edits];
    Edit -- "View Others' Changes" --> SeeChanges[See Real-time Updates from Others];
    UserEdits --> AutoSave["Changes Saved Automatically"];
    AutoSave --> Broadcast[Changes Broadcast to All Users];
    Broadcast --> Sync[All Users' Views Synchronized];
    SeeChanges --> Sync;
    Sync --> Continue[Continue Collaborative Editing];
  ```

### Reviewing and Accepting AI Suggestions

- **Goal:** User wants to review and accept AI-suggested relationships or content.
- **Steps / Diagram:**
  ```mermaid
  graph TD
    Start --> ViewSuggestions[View Dotted Lines or Highlighted Suggestions];
    ViewSuggestions --> Select[Select a Suggestion];
    Select --> Review[Review Details and Confidence Score in Popover];
    Review --> Decision{Accept or Reject?};
    Decision -- Accept --> ApplySuggestion[Apply Suggestion to Knowledge Graph];
    Decision -- Modify --> EditSuggestion[Edit Suggestion Details];
    Decision -- Reject --> DismissSuggestion[Dismiss Suggestion];
    EditSuggestion --> ApplySuggestion;
    ApplySuggestion --> AutoSave["Changes Saved Automatically"];
    DismissSuggestion --> AutoSave;
    AutoSave --> NextSuggestion[Move to Next Suggestion];
  ```

### Managing To-Do Items for Knowledge Completion

- **Goal:** User wants to identify and address incomplete knowledge elements.
- **Steps / Diagram:**
  ```mermaid
  graph TD
    Start --> OpenToDo[Open To-Do List View];
    OpenToDo --> ViewUnfinished[View Unfinished Entities and Relationships];
    ViewUnfinished --> FilterSort[Filter and Sort by Type/Priority];
    FilterSort --> SelectItem[Select To-Do Item];
    SelectItem --> ViewContext[View Item in Context];
    ViewContext --> EditItem[Edit to Complete Missing Information];
    EditItem --> AutoSave["Changes Saved Automatically"];
    AutoSave --> CheckComplete{Now Complete?};
    CheckComplete -- Yes --> RemoveFromList[Remove from To-Do List];
    CheckComplete -- No --> UpdateList[To-Do List Updates];
    RemoveFromList --> NextItem[Move to Next Item];
    UpdateList --> NextItem;
  ```

## Wireframes & Mockups

- **Main Layout:** 
  The interface has a left sidebar containing the logo, user menu, view toggles, and knowledge base selector (if applicable). The main content area displays the active view (wiki, graph, split, to-do list, etc.). No top bar or right sidebar is present. Context-specific controls and information appear in popovers or inline panels when interacting with elements.

- **Graph Visualization Mode:** 
  Full-screen graph view with nodes representing entities and edges representing relationships. Includes zoom controls, search, filtering options, and a mini-map for navigation. Nodes are color-coded by type, with UFCs (untyped entities) having a distinct visual treatment. "Unfinished" entities and relationships have visual indicators showing they're incomplete. AI-suggested relationships appear as dotted lines until approved. Double-clicking on empty canvas creates a new UFC. Clicking on a node or edge opens a popover with properties, comments, and metadata.

- **Wiki Editor Mode:** 
  Rich text editor with formatting toolbar, wiki-link creation tools, and media embedding options. Shows a document outline and allows for section navigation. Wiki-links are highlighted and can be clicked to navigate. AI-suggested content appears with subtle highlighting and accept/reject controls. Entity properties, comments, and metadata are displayed inline or in expandable sections within the wiki page, not in a separate sidebar.

- **Split View Mode:**
  Shows wiki editor and graph visualization side by side with a resizable divider. Changes in either view are reflected in the other in real-time. No additional sidebars are present; all property editing and metadata viewing is done through popovers or inline panels.

- **To-Do List View:** 
  A structured list of unfinished knowledge elements (UFCs and entities/relationships missing required properties). Each item links directly to the relevant entity or relationship for editing. Includes filtering and sorting options, progress indicators, and completion metrics. Items can be assigned to team members with due dates. Unfinished items will not appear in the published view of the knowledge base.

- **Document Upload & Processing:** 
  Interface for uploading documents with progress indicators and a review panel for extracted knowledge. Shows suggested entities and relationships with confidence scores and options to approve or reject. Includes document management tools for organizing and referencing source materials.

- **Version History View:**
  Timeline visualization of changes with user attribution and timestamps. Provides options to view the knowledge graph at any point in history or compare two versions with highlighted differences. Changes are grouped into meaningful units with natural language descriptions.

- **Publishing Configuration:**
  Interface for configuring how the knowledge base will be published and shared. Includes access control settings, appearance customization, content selection, and preview functionality. Provides options for generating permalinks, setting passwords, and inviting specific users. Unfinished entities and relationships are automatically excluded from the published view.

## Component Library / Design System Reference

The Knowledge Graph Wiki Tool will use a custom component library built on Shadcn/ui with Tailwind CSS. Key components include:

- **Entity Cards:** Visual representations of entities with type indicators, key attributes, and interaction controls. UFCs have a distinct visual treatment.
- **Relationship Lines:** Styled connections between entities with labels and directional indicators
- **Property Editors:** Form components for editing entity and relationship properties, appearing in popovers or inline panels
- **Wiki Editor Components:** Text formatting tools, link creation, media embedding
- **Collaboration Indicators:** User avatars, presence indicators, edit attribution markers
- **Navigation Components:** Sidebar menu, tabs, and view toggles
- **Feedback Components:** Notifications, alerts, progress indicators, and confirmation dialogs
- **AI Suggestion Components:** Confidence indicators, accept/reject controls, feedback mechanisms
- **Version Control Components:** Timeline sliders, diff viewers, change summaries
- **Comment Components:** Comment threads, reply chains, mention pickers, formatting tools
- **To-Do Components:** Progress bars, completion indicators, priority markers, assignment badges
- **Popover Components:** Context-sensitive panels that appear when interacting with elements

## Branding & Style Guide Reference

- **Color Palette:** 
  - **Primary:** Black (#000000) and White (#FFFFFF) as base colors
  - **Secondary:** Pastel colors for different entity and relationship types
  - **Accent:** Subtle highlights for interactive elements and selection
  - **Feedback:** Standard colors for success, warning, error, and information states
  - **AI Suggestions:** Distinct color for AI-generated content and suggestions
  - **Completion Status:** Visual indicators for UFCs and unfinished entities/relationships

- **Typography:** 
  - **UI Elements:** Sans-serif font (e.g., Inter) for clarity and readability
  - **User Content:** Modern, low-contrast serif font for wiki content
  - **Hierarchy:** Clear size and weight differentiation for headings and body text
  - **Code/Technical:** Monospace font for technical content or queries

- **Iconography:** 
  - Minimalist, consistent icon set for actions and entity types
  - Custom icons for domain-specific concepts
  - Clear visual distinction between different types of actions
  - Status indicators for collaboration, AI suggestions, and completion status

- **Spacing & Grid:** 
  - Consistent spacing scale based on 4px increments
  - Responsive grid system that adapts to different screen sizes
  - Automatic grid snapping for graph layout
  - Consistent padding and margins throughout the interface

## Accessibility (AX) Requirements

- **Target Compliance:** WCAG 2.1 AA level
- **Specific Requirements:** 
  - All functionality must be accessible via keyboard navigation
  - Multiple color schemes (light mode, dark mode, and high contrast)
  - Interactive elements must have appropriate focus states
  - Screen reader compatibility for all core functions
  - Support for system font size adjustments
  - Audio feedback option for important actions
  - Proper ARIA attributes for complex components
  - Sufficient color contrast for text and interactive elements
  - Alternative text for graph visualizations
  - Keyboard shortcuts with customization options

## Responsiveness

- **Breakpoints:** 
  - Desktop: 1400px and above (primary focus)
  - Laptop: 1024px - 1399px
  - Tablet: 768px - 1023px (limited functionality)
  - Mobile: Below 768px (view-only mode)

- **Adaptation Strategy:** 
  - **Desktop:** Full functionality with split view and advanced graph visualization
  - **Laptop:** Optimized layout with possibly reduced split view size
  - **Tablet:** Focus on either wiki or graph view with simplified controls
  - **Mobile:** Read-only access to wiki content with basic navigation
  - **Responsive Components:** UI elements that adapt to available space without losing functionality

## Interactive Behaviors & Micro-interactions

- **Real-time Collaboration Indicators:**
  - Cursor position sharing with user attribution
  - Selection highlighting with user colors
  - Typing indicators in text fields
  - Presence avatars showing active users
  - Activity feed for recent changes

- **Graph Interaction Patterns:**
  - Zoom and pan with mouse/trackpad gestures
  - Double-click on canvas to create new UFC
  - Node dragging with grid snapping
  - Relationship creation by dragging between nodes
  - Context menus for common actions
  - Multi-select for batch operations
  - Auto-layout with animation

- **Automatic Saving:**
  - All changes are saved automatically without requiring manual save actions
  - Subtle visual indicators show saving status (saving, saved, error)
  - Offline changes are queued for syncing when connection is restored

- **UFC and Unfinished Entity Interactions:**
  - Visual indicators for UFCs and unfinished entities/relationships
  - Quick access to required properties that need completion
  - Batch operations for converting multiple UFCs to typed entities
  - Filtering options to show/hide UFCs and unfinished items in the graph view

- **AI Suggestion Interactions:**
  - Hover to preview suggestions
  - Click to view details and confidence score in popover
  - Accept/reject buttons with clear feedback
  - Suggestion refinement controls
  - Feedback mechanism for improving AI quality

- **Version History Interactions:**
  - Timeline scrubbing to view different versions
  - Side-by-side comparison with synchronized scrolling
  - Change highlighting with clear visual indicators
  - Natural language summaries of changes
  - One-click restore functionality

## Change Log

| Change        | Date       | Version | Description                                                                                                          | Author                     |
| ------------- | ---------- | ------- | -------------------------------------------------------------------------------------------------------------------- | -------------------------- |
| Initial Draft | 06/06/2025 | 0.1     | Created initial UI/UX specification                                                                                  | Desiree (Design Architect) |
| Update        | 06/06/2025 | 0.2     | Enhanced specification with additional user flows, interaction details, and component descriptions                   | Desiree (Design Architect) |
| Revision      | 11/06/2025 | 0.3     | Revised UI structure: removed top bar and right sidebar, added UFC concept, automatic saving, and updated user flows | Desiree (Design Architect) |