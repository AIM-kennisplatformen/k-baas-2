const { spawn } = require('child_process');
const path = require('path');

async function testBasicMCP() {
    console.log('🔍 Testing Basic MCP (no AI)...');
    
    const serverPath = path.join(__dirname, 'node_modules/.bin/mcp-github-project-manager');
    
    const serverProcess = spawn('node', [serverPath], {
        env: {
            // Only GitHub credentials, no AI
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
        console.log('STDERR:', data.toString());
    });

    // Wait for startup
    await new Promise(resolve => setTimeout(resolve, 4000));

    // Try initialize with different protocol version
    console.log('Testing initialize...');
    const initRequest = {
        jsonrpc: "2.0",
        id: 1,
        method: "initialize",
        params: {
            protocolVersion: "2024-11-05",
            capabilities: {
                tools: {}
            },
            clientInfo: { name: "debug-client", version: "1.0.0" }
        }
    };
    serverProcess.stdin.write(JSON.stringify(initRequest) + '\n');
    
    await new Promise(resolve => setTimeout(resolve, 2000));

    serverProcess.kill('SIGTERM');
    console.log('Test completed');
}

testBasicMCP().catch(console.error); 