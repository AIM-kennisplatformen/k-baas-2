const { spawn } = require('child_process');
const path = require('path');

async function discoverMCPTools() {
    console.log('🔍 Discovering Available MCP Tools...');
    
    const serverPath = path.join(__dirname, 'node_modules/.bin/mcp-github-project-manager');
    
    const serverProcess = spawn('node', [serverPath], {
        env: {
            ...process.env,
            GITHUB_TOKEN: process.env.GITHUB_TOKEN,
            GITHUB_OWNER: 'HAN-AIM-CMD-WG',
            GITHUB_REPO: 'k-baas-2'
        },
        stdio: ['pipe', 'pipe', 'pipe']
    });

    serverProcess.stdout.on('data', (data) => {
        const chunk = data.toString();
        console.log('STDOUT:', chunk);
    });

    serverProcess.stderr.on('data', (data) => {
        const chunk = data.toString();
        // Look for tool registration messages
        if (chunk.includes('Tool registered')) {
            console.log('FOUND TOOL REGISTRATION:', chunk);
        }
    });

    // Wait for startup and tool registration
    await new Promise(resolve => setTimeout(resolve, 5000));

    serverProcess.kill('SIGTERM');
    console.log('Tool discovery test completed.');
}

discoverMCPTools().catch(console.error); 