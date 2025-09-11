# GitHub Project Manager MCP Server Setup

Deze handleiding legt uit hoe je de GitHub Project Manager MCP server installeert en configureert voor gebruik met Cursor en ons team.

## Overzicht

De GitHub Project Manager MCP server biedt AI-powered projectmanagement functies voor GitHub repositories, inclusief:
- Project en milestone management
- AI-powered PRD generatie
- Task generation en complexity analysis
- Requirements traceability
- Sprint planning en tracking

## Installatie

### Optie 1: Installeer via npm (Aanbevolen)

```bash
# Installeer globaal
npm install -g mcp-github-project-manager

# Of installeer in je project
npm install mcp-github-project-manager
```

### Optie 2: Installeer vanuit source

```bash
# Clone de repository
git clone https://github.com/kunwarVivek/mcp-github-project-manager.git
cd mcp-github-project-manager

# Installeer dependencies
npm install
# of
pnpm install

# Build het project
npm run build
```

## Configuratie

### 1. Environment Variables

Kopieer het voorbeeld environment file:

```bash
cp .env.example .env
```

Of maak een nieuwe `.env` file met de volgende configuratie:

```env
# GitHub Configuration (VERPLICHT)
GITHUB_TOKEN=your_github_token_here
GITHUB_OWNER=HAN-AIM-CMD-WG
GITHUB_REPO=k-baas-2

# AI Provider Configuration (Minimaal een van deze is verplicht)
ANTHROPIC_API_KEY=your_anthropic_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
GOOGLE_API_KEY=your_google_api_key_here
PERPLEXITY_API_KEY=your_perplexity_api_key_here

# AI Model Configuration (optioneel - gebruikt defaults als niet opgegeven)
AI_MAIN_MODEL=claude-3-5-sonnet-20241022
AI_RESEARCH_MODEL=perplexity-llama-3.1-sonar-large-128k-online
AI_FALLBACK_MODEL=gpt-4o
AI_PRD_MODEL=claude-3-5-sonnet-20241022

# AI Task Generation Configuration (optioneel)
MAX_TASKS_PER_PRD=50
DEFAULT_COMPLEXITY_THRESHOLD=7
MAX_SUBTASK_DEPTH=3
AUTO_DEPENDENCY_DETECTION=true
AUTO_EFFORT_ESTIMATION=true

# Enhanced Task Context Generation Configuration (optioneel)
ENHANCED_TASK_GENERATION=true
AUTO_CREATE_TRACEABILITY=true
AUTO_GENERATE_USE_CASES=true
AUTO_CREATE_LIFECYCLE=true
ENHANCED_CONTEXT_LEVEL=standard
INCLUDE_BUSINESS_CONTEXT=false
INCLUDE_TECHNICAL_CONTEXT=false
INCLUDE_IMPLEMENTATION_GUIDANCE=false
```

### 2. GitHub Token Permissions

Je GitHub token moet de volgende permissions hebben:

- `repo` (Full repository access)
- `project` (Project access) 
- `write:org` (Organization access)

**Hoe maak je een GitHub token aan:**

1. Ga naar GitHub.com → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Klik "Generate new token (classic)"
3. Selecteer de bovenstaande scopes
4. Kopieer de token naar je `.env` file

### 3. AI Provider API Keys

Je hebt minimaal één AI provider nodig. Hier zijn de links:

- **Anthropic Claude**: [https://console.anthropic.com/](https://console.anthropic.com/)
- **OpenAI**: [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
- **Google AI**: [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey)
- **Perplexity**: [https://www.perplexity.ai/settings/api](https://www.perplexity.ai/settings/api)

## Cursor MCP Configuratie

### 1. Cursor Configuratie Bestand

Voeg de volgende configuratie toe aan je Cursor MCP settings (`~/.cursor/mcp_servers.json`):

```json
{
  "mcpServers": {
    "github-project-manager": {
      "command": "npx",
      "args": ["-y", "mcp-github-project-manager"],
      "env": {
        "GITHUB_TOKEN": "your_github_token_here",
        "GITHUB_OWNER": "HAN-AIM-CMD-WG", 
        "GITHUB_REPO": "k-baas-2",
        "ANTHROPIC_API_KEY": "your_anthropic_api_key_here",
        "OPENAI_API_KEY": "your_openai_api_key_here"
      }
    }
  }
}
```

**Alternatief voor Windows:**

```json
{
  "mcpServers": {
    "github-project-manager": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "mcp-github-project-manager"],
      "env": {
        "GITHUB_TOKEN": "your_github_token_here",
        "GITHUB_OWNER": "HAN-AIM-CMD-WG",
        "GITHUB_REPO": "k-baas-2",
        "ANTHROPIC_API_KEY": "your_anthropic_api_key_here",
        "OPENAI_API_KEY": "your_openai_api_key_here"
      }
    }
  }
}
```

### 2. Test de Installatie

Na het configureren:

1. **Herstart Cursor volledig**
2. Open een nieuwe chat
3. Test een van deze commando's:
   - `@github-project-manager list projects`
   - `@github-project-manager list milestones`
   - `@github-project-manager list issues`

## Beschikbare Funcionaliteiten

### Core Project Management
- **Projects**: Maken, bewerken, weergeven van GitHub Projects v2
- **Milestones**: CRUD operaties voor milestones
- **Issues**: Volledig issue management met custom fields
- **Sprint Planning**: Inclusief metrics tracking

### AI-Powered Features
- **PRD Generation**: Multi-provider AI ondersteuning voor uitgebreide PRD creatie
- **Task Generation**: AI-powered parsing van PRDs naar uitvoerbare taken
- **Feature Addition**: Slimme feature toevoeging met impact analyse
- **Task Complexity Analysis**: Gedetailleerde AI analyse met risico beoordeling
- **Requirements Traceability**: End-to-end traceerbaarheid met coverage analyse

## Troubleshooting

### Veel voorkomende problemen

1. **Module Not Found Errors**
   ```bash
   # Probeer bunx in plaats van npx
   bunx -y mcp-github-project-manager
   ```

2. **Permission Issues**
   - Controleer of je GitHub token de juiste permissions heeft
   - Zorg dat je toegang hebt tot de HAN-AIM-CMD-WG organisatie

3. **Cursor Connect Issues**
   - Herstart Cursor volledig na config wijzigingen
   - Controleer of de MCP configuratie correct geformatteerd is (JSON syntax)
   - Kijk in Cursor's output panel voor error messages

4. **Environment Variables**
   - Zorg dat alle API keys geldig zijn
   - Test je GitHub token met: `curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user`

### Debugging

Om te testen of de server werkt buiten Cursor:

```bash
# Test lokaal
npx -y mcp-github-project-manager
```

### Logs en Diagnostics

Als je problemen hebt, check:
- Cursor's Developer Tools (Help → Toggle Developer Tools)
- MCP server logs in Cursor's output panel
- GitHub API rate limits

## Team Setup

Voor teamleden die dit ook willen gebruiken:

1. **Clone deze repository**
2. **Kopieer `.env.example` naar `.env`**
3. **Voeg je eigen API keys toe**
4. **Volg de Cursor configuratie stappen hierboven**
5. **Test de installatie**

## Meer Informatie

- **Bron Repository**: [https://github.com/kunwarVivek/mcp-github-project-manager](https://github.com/kunwarVivek/mcp-github-project-manager)
- **MCP Protocol**: [https://spec.modelcontextprotocol.io/](https://spec.modelcontextprotocol.io/)
- **GitHub Projects API**: [https://docs.github.com/en/issues/planning-and-tracking-with-projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects)

## Ondersteuning

Voor vragen of problemen:
1. Check eerst deze README
2. Kijk in de troubleshooting sectie
3. Zoek in de GitHub Issues van het originele project
4. Vraag hulp in ons team chat 