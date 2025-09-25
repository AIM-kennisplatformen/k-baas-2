# Data Models

The system uses a multi-database architecture on the TypeDB server to separate system management from domain-specific knowledge:

## Database Architecture

**Core Database (`k-baas-core`)**:
- Contains user management, authentication, teams, and knowledge base metadata
- Single shared database for all system-level entities
- Fixed schema defined at deployment time

**Knowledge Base Databases (`kb-{uuid}`)**:
- Individual database per knowledge base for domain-specific content
- Each inherits from a generic knowledge base schema
- Domain-specific concepts and relationships added dynamically
- Schema evolves based on user-defined domain requirements

## Core Database Schema

### User

**Purpose:** System users supporting both username/password and OAuth authentication

**Key Fields:**
- user_id: string (UUID) - Unique identifier
- email: string - Primary authentication identifier
- username: string - Display name
- password_hash: string - Secure password storage (null for OAuth-only users)
- oauth_provider: string - OAuth provider (google, github, microsoft, etc.) [optional]
- oauth_id: string - OAuth provider user ID [optional]
- created_at: datetime - Account creation
- last_login: datetime - Most recent login
- is_active: boolean - Account status

**Relationships:**
- Member of Teams (via team-membership)
- Owner of KnowledgeBases (via kb-ownership)

### Team

**Purpose:** Groups of users with shared access to knowledge bases

**Key Fields:**
- team_id: string (UUID) - Unique identifier
- name: string - Team display name
- description: string - Team purpose
- created_at: datetime - Creation timestamp

**Relationships:**
- Has Members (via team-membership)
- Has Access to KnowledgeBases (via team-kb-access)

### KnowledgeBase

**Purpose:** Metadata about individual knowledge base databases

**Key Fields:**
- kb_id: string (UUID) - Unique identifier and database name suffix
- name: string - Human-readable name
- description: string - Purpose and scope
- schema_template: string - Base schema template used
- database_name: string - Actual TypeDB database name (kb-{uuid})
- created_by: string (UUID) - Creating user
- created_at: datetime - Creation timestamp
- is_public: boolean - Public visibility

**Relationships:**
- Owned by User (via kb-ownership)
- Accessible by Teams (via team-kb-access)

## Generic Knowledge Base Schema

All knowledge base databases inherit this base schema:

### Concept

**Purpose:** Knowledge graph nodes representing domain concepts (no separate WikiPage entity)

**Key Fields:**
- concept_id: string (UUID) - Unique identifier
- concept_type: string - Domain-specific type
- name: string - Primary label
- short_description: string - Brief summary field
- description: string - Full wiki-style content (rich text from Lexical editor)
- completeness_score: double - Schema compliance metric
- created_by: string (UUID) - Creating user ID
- created_at: datetime - Creation timestamp
- updated_at: datetime - Last modification

**Notes:**
- Multiple users can edit concepts and their descriptions
- No base properties - defined by concept subtypes
- Description field contains wiki content, eliminating need for separate WikiPage entity

**Relationships:**
- Connected via ConceptRelationships

### ConceptRelationship

**Purpose:** Bidirectional typed connections between concepts with directional labels

**Key Fields:**
- relationship_id: string (UUID) - Unique identifier
- relationship_type: string - Domain-specific type
- forward_label: string - Label format: "SourceType➤relation➤TargetType" (e.g., "Employee➤works-for➤Organization")
- backward_label: string - Label format: "TargetType➤relation➤SourceType" (e.g., "Organization➤employs➤Employee")
- created_by: string (UUID) - Creating user ID
- created_at: datetime - Creation timestamp
- updated_at: datetime - Last modification

**Notes:**
- No base properties - subtypes define specific properties
- No strength attribute - confidence handled by subtypes if needed
- Directional labeling using ➤ separator for clear relationship reading

**Relationships:**
- Connects source and target Concepts

### Schema Inheritance Pattern

Domain-specific knowledge bases extend the generic schema by:
1. **Inheriting** Concept and ConceptRelationship base types
2. **Adding** domain-specific concept types as subtypes of Concept
3. **Adding** domain-specific relationship types as subtypes of ConceptRelationship
4. **Defining** custom fields on subtypes

**Example Domain Extension:**
```
# Generic schema provides: Concept, ConceptRelationship
# Academic domain adds:
person sub concept,
    owns affiliation,
    owns research-area;

organization sub concept,
    owns founded-year,
    owns location;

works-at sub concept-relationship,
    owns start-date,
    owns position;
```
