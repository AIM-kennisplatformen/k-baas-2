# Project Brief: Knowledge Graph Wiki Tool

## Introduction / Problem Statement

Domain experts need an intuitive way to collaboratively build and maintain structured knowledge in their fields of expertise. Current solutions either require technical expertise (graph databases, coding) or lack the ability to represent complex relationships (traditional wikis, document systems). This project aims to create a tool that combines the rich content capabilities of wikis with the relationship-focused structure of knowledge graphs, all presented through an intuitive interface designed for non-technical domain experts.

## Vision & Goals

- **Vision:** Create an intuitive, collaborative platform that empowers domain experts to build, visualize, and share interconnected knowledge without requiring technical expertise.

- **Primary Goals:**
  - Goal 1: Develop an intuitive interface that allows non-technical users to create and edit both wiki content and knowledge graph elements.
  - Goal 2: Implement bidirectional synchronization between wiki content and knowledge graph visualization.
  - Goal 3: Integrate AI assistance to suggest relationships, summaries, and identify knowledge gaps without overriding user agency.
  - Goal 4: Enable real-time collaboration for teams working on shared knowledge bases.
  - Goal 5: Provide a system for identifying and addressing incomplete knowledge through a structured to-do list.

- **Success Metrics (Initial Ideas):**
  - User engagement metrics (time spent creating/editing content)
  - Knowledge base growth (entities, relationships, wiki pages created)
  - Completeness metrics (percentage of entities with complete information)
  - Collaboration metrics (number of contributors, edits per user)
  - User satisfaction scores for non-technical domain experts

## Target Audience / Users

The primary users are domain experts with specialized knowledge but limited technical expertise. They are professionals who need to document, organize, and share complex information within their fields. They work in collaborative teams where knowledge sharing is essential, but they lack the technical skills to use traditional knowledge graph tools. They value intuitive interfaces, visual representations of relationships, and tools that help them focus on content rather than technical implementation.

## Key Features / Scope (High-Level Ideas for MVP)

- **Integrated Wiki-Graph Interface:** A unified interface where users can edit wiki content with rich text formatting and simultaneously visualize/edit the knowledge graph structure.

- **Bidirectional Synchronization:** Changes in wiki content automatically update the graph and vice versa, maintaining consistency between both views.

- **Schema-Based Knowledge Structure:** Pre-defined schemas that guide users in creating properly structured knowledge without requiring them to design the schema themselves.

- **Intuitive Entity Creation:** Multiple pathways to create entities, including through wiki-links in text and direct manipulation of the graph visualization.

- **AI-Assisted Relationship Suggestions:** System suggests potential relationships between entities (shown as dotted lines) that users can approve or reject.

- **Document Upload & Knowledge Extraction:** Users can upload documents from which the system suggests new entities or relationships for approval.

- **To-Do List for Knowledge Completion:** A system-generated list of incomplete entities and relationships based on schema-defined completeness criteria.

- **Visual Cues for Knowledge Quality:** Subtle visual indicators showing the completeness or importance of entities within the graph.

- **Real-Time Collaboration:** Google Docs/Miro-style collaboration allowing multiple users to work simultaneously on the knowledge base.

- **TypeDB Integration:** Backend integration with TypeDB to support complex relationship types with additional properties.

- **Rich Media Support:** Wiki pages support embedding of images, videos, and hyperlinks.

## Post MVP Features / Scope and Ideas

- **Interactive Web Publishing:** Ability to publish knowledge bases as interactive web content for broader sharing.

- **Version History & Control:** Tracking changes to both wiki content and graph structure over time.

- **Advanced Collaboration Tools:** Annotation layers, focus mode, and activity feeds to enhance team coordination.

- **Knowledge Health Metrics:** Dashboard showing overall completeness and quality of the knowledge base.

- **Cross-Knowledge Base Linking:** Ability to reference or import entities from other knowledge bases.

- **Mobile-Optimized Views:** Responsive design for accessing knowledge bases on various devices.

- **API Access:** Programmatic access to knowledge for integration with other systems.

- **Advanced Search & Filtering:** More sophisticated ways to query and explore the knowledge base.

## Known Technical Constraints or Preferences

- **Constraints:**
  - Must use TypeDB as the knowledge graph backend
  - Must support rich text formatting and media embedding in wiki content
  - Must be accessible to non-technical users

- **Initial Architectural Preferences:**
  - Web-based application for cross-platform accessibility
  - Single repository with separate frontend/ and backend/ directories (no monorepo tools)
  - Real-time collaboration capabilities similar to Google Docs or Miro
  - Integration with LLM services for AI assistance features

- **Risks:**
  - Balancing simplicity for non-technical users with power/flexibility for complex knowledge representation
  - Ensuring performance with large knowledge graphs and multiple concurrent users
  - Managing AI suggestion quality to maintain user trust and knowledge integrity

- **User Preferences:**
  - Intuitive, minimalistic, and beautiful UI
  - No mode switching (simple vs. advanced)
  - System suggestions must always require explicit user approval
  - Real-time collaboration among teams of equals
  - Visual manipulation of the knowledge graph

## Relevant Research (Optional)

Initial research should explore:
- Existing knowledge graph visualization techniques and best practices
- UI patterns for non-technical users working with complex data structures
- Real-time collaboration implementations in similar tools (Miro, Google Docs)
- TypeDB capabilities and limitations for this use case
- LLM integration patterns for knowledge graph applications

## PM Prompt

This Project Brief provides the full context for the Knowledge Graph Wiki Tool. Please start in 'PRD Generation Mode', review the brief thoroughly to work with the user to create the PRD section by section 1 at a time, asking for any necessary clarification or suggesting improvements as your mode 1 programming allows.