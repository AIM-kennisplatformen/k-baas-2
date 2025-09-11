# MCP GitHub Project Manager Setup Guide

## 🎯 Current Status
Je hebt al een correcte MCP configuratie in `/Users/wouter/.cursor/mcp.json`, maar de server werkt niet naar behoren.

## 🔧 Oplossingen

### Optie 1: Quick Fix - NPX (Aanbevolen)
Je huidige configuratie gebruikt al npx. Test deze:

```bash
# Test of de server werkt
npx -y mcp-github-project-manager --help

# Test met je configuratie
GITHUB_TOKEN="your_github_token_here" \
GITHUB_OWNER="HAN-AIM-CMD-WG" \
GITHUB_REPO="k-baas-2" \
npx -y mcp-github-project-manager
```

### Optie 2: Docker Setup
Als npx problemen geeft, gebruik dan Docker:

```bash
# Bouw de Docker image
docker build -f Dockerfile.mcp -t github-project-manager-mcp .

# Run met Docker
docker run -i --rm \
  -e GITHUB_TOKEN="your_github_token_here" \
  -e GITHUB_OWNER="HAN-AIM-CMD-WG" \
  -e GITHUB_REPO="k-baas-2" \
  github-project-manager-mcp
```

Dan update je MCP configuratie naar:
```json
{
  "mcpServers": {
    "github-project-manager": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "github-project-manager-mcp"],
      "env": {
        "GITHUB_TOKEN": "your_github_token_here",
        "GITHUB_OWNER": "HAN-AIM-CMD-WG",
        "GITHUB_REPO": "k-baas-2"
      }
    }
  }
}
```

### Optie 3: Bunx (Alternative)
Als npx niet werkt, probeer bunx:

Update je MCP configuratie naar:
```json
{
  "mcpServers": {
    "github-project-manager": {
      "command": "bunx",
      "args": ["-y", "mcp-github-project-manager"],
      "env": {
        "GITHUB_TOKEN": "your_github_token_here",
        "GITHUB_OWNER": "HAN-AIM-CMD-WG",
        "GITHUB_REPO": "k-baas-2"
      }
    }
  }
}
```

## 🔍 Troubleshooting

### GitHub Token Permissions
Zorg ervoor dat je token deze scopes heeft:
- `repo` (full control of private repositories)
- `project` (full control of projects)  
- `read:org` (read org and team membership, read org projects)

### Test de Connectiviteit
```bash
# Test GitHub API access (vervang YOUR_TOKEN met je echte token)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.github.com/repos/HAN-AIM-CMD-WG/k-baas-2
```

## 🔄 Na Setup
1. Herstart Cursor of VScode volledig
2. Test de MCP server in een nieuwe chat
3. Probeer commando's zoals: "List my GitHub projects" of "Create a new milestone"

## 🆘 Als niets werkt
- Check de Cursor logs: Help > Show Output > MCP
- Probeer de server handmatig te runnen voor debugging
- Check of er firewall/proxy issues zijn

## ⚠️ VEILIGHEID
- **NOOIT** hardcode je GitHub token in bestanden die naar git gaan
- Gebruik altijd environment variabelen of externe configuratie
- Voeg gevoelige bestanden toe aan `.gitignore` 