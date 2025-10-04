# Knowledge Graph Wiki Tool voor DEMAND

## Project Samenvatting

Dit project ontwikkelt een intuïtief platform waarmee domeinexperts zonder technische kennis collaboratief een knowledge base (k-baas) kunnen bouwen, visualiseren en delen. De tool combineert de rijke content-mogelijkheden van wiki's met de relatiegerichte structuur van concept maps.

### Visie en Doelen

**Visie:** Een toegankelijk, collaboratief platform creëren dat domeinexperts in staat stelt om onderling verbonden kennis te bouwen zonder technische expertise.

**Primaire Doelen:**
- Ontwikkel een intuïtieve interface voor niet-technische gebruikers om wiki-content en kennisgraafelementen te maken en bewerken
- Implementeer bidirectionele synchronisatie tussen wiki-content en kennisgraafvisualisatie
- Integreer AI-assistentie voor relatie-suggesties, samenvattingen en het identificeren van kennisgaten
- Real-time collaboratie voor teams die werken aan gedeelde kennisbases
- Een systeem voor het identificeren en aanpakken van onvolledige kennis via gestructureerde takenlijsten

### Doelgroep

De primaire gebruikers zijn domeinexperts met gespecialiseerde kennis maar beperkte technische expertise. Professionals die complexe informatie binnen hun vakgebied moeten documenteren, organiseren en delen, maar de technische vaardigheden missen om traditionele kennisgraaf-tools te gebruiken.

### Kernfuncties (MVP)

- **Geïntegreerde Wiki-Graaf Interface:** Een verenigde interface waar gebruikers wiki-content kunnen bewerken met rich text formatting en tegelijkertijd de kennisgraafstructuur kunnen visualiseren/bewerken
- **Bidirectionele Synchronisatie:** Wijzigingen in wiki-content updaten automatisch de graaf en vice versa
- **Schema-gebaseerde Kennisstructuur:** Voorgedefinieerde schema's die gebruikers begeleiden bij het creëren van gestructureerde kennis
- **Intuïtieve Entiteit Creatie:** Meerdere paden om entiteiten te creëren, inclusief via wiki-links en directe manipulatie van de graafvisualisatie
- **AI-geassisteerde Relatie-suggesties:** Het systeem suggereert potentiële relaties tussen entiteiten die gebruikers kunnen goedkeuren of afwijzen
- **Takenlijst voor Kennisvoltooiing:** Een systeemgegenereerde lijst van onvolledige entiteiten en relaties
- **Real-time Collaboratie:** Google Docs/Miro-stijl collaboratie waarbij meerdere gebruikers gelijktijdig kunnen werken
- **TypeDB Integratie:** Backend integratie met TypeDB voor complexe relatietypes met extra eigenschappen

### Technische Architectuur

- **Backend:** TypeDB als kennisgraaf database
- **API Framework:** FastAPI (Python)
- **Frontend:** React 19 (met Vite)
- **Rich Text Editor:** Lexical
- **Graph Visualization:** React Flow
- **Real-time Communication:** Socket.IO

## Documentatie

Voor gedetailleerde informatie, raadpleeg de volgende documenten:

- [PRD Documentatie](prd/) - Product Requirements Document
- [Architectuur Documentatie](architecture/) - Technische architectuur en implementatie
- [Project Brief](knowledge-graph-wiki-project-brief.md) - Volledige projectbeschrijving

## Ontwikkelproces

Dit project maakt gebruik van het BMAD (Business Modeling & Agent Development) framework voor gestructureerde ontwikkelworkflows en kwaliteitsborging. Zie [AGENTS.md](../AGENTS.md) voor meer informatie over het ontwikkelproces en de beschikbare agent-persona's.
