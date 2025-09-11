#!/usr/bin/env node

/**
 * GitHub Sub-Issue Automation Script
 * Creates parent-child relationships between Story and Task issues using GitHub's Sub-Issues API
 * 
 * Usage:
 *   node github-subissue-automation.js          // Full bulk execution
 *   node github-subissue-automation.js --test   // Single test
 *   node github-subissue-automation.js --check  // Status verification
 */

const https = require('https');

// Configuration
const REPO = 'HAN-AIM-CMD-WG/k-baas-2';
const TOKEN = process.env.GITHUB_TOKEN;

if (!TOKEN) {
    console.error('❌ GITHUB_TOKEN environment variable not set');
    process.exit(1);
}

// Sub-issue mappings - complete Epic 1 & 2 for verification
const SUBISSUE_MAPPINGS = {
    // Epic 1: Foundation & Infrastructure (complete)
    3: [22, 23, 24, 25],           // S1.3 → T1.3.x (4 tasks)
    5: [9, 10, 11, 12, 13, 14],    // S1.1 → T1.1.x (6 tasks)
    6: [15, 16, 17, 18, 19, 20, 21], // S1.2 → T1.2.x (7 tasks)
    
    // Epic 2: Authentication & User Management (complete)
    4: [26, 27, 28, 29],           // S2.1 → T2.1.x (4 tasks)
    7: [30, 31, 32, 33],           // S2.2 → T2.2.x (4 tasks)
    8: [34, 35, 36, 37]            // S2.3 → T2.3.x (4 tasks)
};

/**
 * Makes GitHub GraphQL API request for sub-issues
 */
function makeGraphQLRequest(query, variables = {}) {
    return new Promise((resolve, reject) => {
        const data = JSON.stringify({
            query: query,
            variables: variables
        });

        const options = {
            hostname: 'api.github.com',
            path: '/graphql',
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${TOKEN}`,
                'User-Agent': 'GitHub-SubIssue-Script',
                'Content-Type': 'application/json',
                'GraphQL-Features': 'sub_issues'  // Required header for sub-issues
            }
        };

        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                try {
                    const parsed = JSON.parse(responseData);
                    if (res.statusCode >= 200 && res.statusCode < 300) {
                        resolve(parsed);
                    } else {
                        reject(new Error(`HTTP ${res.statusCode}: ${parsed.message || responseData}`));
                    }
                } catch (e) {
                    reject(new Error(`Parse error: ${e.message}`));
                }
            });
        });

        req.on('error', reject);
        req.write(data);
        req.end();
    });
}

/**
 * Makes GitHub REST API request
 */
function makeRequest(path, method = 'GET', data = null) {
    return new Promise((resolve, reject) => {
        const options = {
            hostname: 'api.github.com',
            path: path,
            method: method,
            headers: {
                'Authorization': `token ${TOKEN}`,
                'User-Agent': 'GitHub-SubIssue-Script',
                'Accept': 'application/vnd.github.v3+json',
                'Content-Type': 'application/json'
            }
        };

        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                try {
                    const parsed = JSON.parse(responseData);
                    if (res.statusCode >= 200 && res.statusCode < 300) {
                        resolve(parsed);
                    } else {
                        reject(new Error(`HTTP ${res.statusCode}: ${parsed.message || responseData}`));
                    }
                } catch (e) {
                    reject(new Error(`Parse error: ${e.message}`));
                }
            });
        });

        req.on('error', reject);
        
        if (data) {
            req.write(JSON.stringify(data));
        }
        
        req.end();
    });
}

/**
 * Get issue node ID using REST API
 */
async function getIssueNodeId(issueNumber) {
    try {
        const issue = await makeRequest(`/repos/${REPO}/issues/${issueNumber}`);
        return issue.node_id;
    } catch (error) {
        throw new Error(`Failed to get node ID for issue #${issueNumber}: ${error.message}`);
    }
}

/**
 * Create sub-issue relationship using GraphQL API
 */
async function createSubIssue(parentIssueNumber, childIssueNumber) {
    try {
        console.log(`🔗 Creating sub-issue: #${childIssueNumber} → parent #${parentIssueNumber}`);
        
        // Get node IDs for both issues
        const [parentNodeId, childNodeId] = await Promise.all([
            getIssueNodeId(parentIssueNumber),
            getIssueNodeId(childIssueNumber)
        ]);
        
        // Get issue details for logging
        const [parentIssue, childIssue] = await Promise.all([
            makeRequest(`/repos/${REPO}/issues/${parentIssueNumber}`),
            makeRequest(`/repos/${REPO}/issues/${childIssueNumber}`)
        ]);
        
        console.log(`   Parent: ${parentIssue.title}`);
        console.log(`   Child:  ${childIssue.title}`);
        
        // Create sub-issue relationship using GraphQL
        const mutation = `
            mutation AddSubIssue($issueId: ID!, $subIssueId: ID!) {
                addSubIssue(input: { issueId: $issueId, subIssueId: $subIssueId }) {
                    issue {
                        title
                        number
                    }
                    subIssue {
                        title
                        number
                    }
                }
            }
        `;
        
        const variables = {
            issueId: parentNodeId,
            subIssueId: childNodeId
        };
        
        const result = await makeGraphQLRequest(mutation, variables);
        
        if (result.errors) {
            throw new Error(`GraphQL errors: ${JSON.stringify(result.errors)}`);
        }
        
        console.log(`   ✅ Sub-issue relationship created successfully`);
        return true;
        
    } catch (error) {
        console.error(`   ❌ Error creating sub-issue: ${error.message}`);
        return false;
    }
}

/**
 * Process all sub-issue mappings
 */
async function processAllSubIssues() {
    console.log('🚀 Starting GitHub Sub-Issue Creation Process\n');
    
    let totalSuccess = 0;
    let totalAttempts = 0;
    
    for (const [parentIssue, childIssues] of Object.entries(SUBISSUE_MAPPINGS)) {
        console.log(`\n📊 Processing Story #${parentIssue} → ${childIssues.length} tasks`);
        
        for (const childIssue of childIssues) {
            totalAttempts++;
            const success = await createSubIssue(parseInt(parentIssue), childIssue);
            if (success) totalSuccess++;
            
            // Small delay to avoid rate limiting
            await new Promise(resolve => setTimeout(resolve, 1000));
        }
    }
    
    console.log(`\n✅ Sub-Issue Creation Complete!`);
    console.log(`   Success: ${totalSuccess}/${totalAttempts} relationships created`);
    console.log(`   Total: ${totalSuccess} parent-child relationships active`);
}

/**
 * Test single sub-issue creation
 */
async function testSingle() {
    console.log('🧪 Testing single sub-issue creation');
    const firstMapping = Object.entries(SUBISSUE_MAPPINGS)[0];
    const [parentIssue, childIssues] = firstMapping;
    const success = await createSubIssue(parseInt(parentIssue), childIssues[0]);
    if (success) {
        console.log('✅ Test successful! Ready for bulk processing.');
    } else {
        console.log('❌ Test failed. Check API permissions.');
    }
}

/**
 * Check existing sub-issues for all parents
 */
async function checkExistingSubIssues(parentIssueNumber) {
    try {
        const parentNodeId = await getIssueNodeId(parentIssueNumber);
        
        const query = `
            query GetSubIssues($issueId: ID!) {
                node(id: $issueId) {
                    ... on Issue {
                        title
                        number
                        subIssues(first: 50) {
                            nodes {
                                title
                                number
                            }
                        }
                        subIssuesSummary {
                            total
                            completed
                            percentCompleted
                        }
                    }
                }
            }
        `;
        
        const result = await makeGraphQLRequest(query, { issueId: parentNodeId });
        
        if (result.errors) {
            throw new Error(`GraphQL errors: ${JSON.stringify(result.errors)}`);
        }
        
        const issue = result.data.node;
        console.log(`\n📋 Issue #${parentIssueNumber}: ${issue.title}`);
        console.log(`   Sub-issues: ${issue.subIssuesSummary.total}`);
        console.log(`   Completed: ${issue.subIssuesSummary.completed} (${issue.subIssuesSummary.percentCompleted}%)`);
        
        if (issue.subIssues.nodes.length > 0) {
            console.log('   Current sub-issues:');
            issue.subIssues.nodes.forEach(subIssue => {
                console.log(`     - #${subIssue.number}: ${subIssue.title}`);
            });
        }
        
        return issue.subIssues.nodes;
        
    } catch (error) {
        console.error(`❌ Error checking sub-issues for #${parentIssueNumber}: ${error.message}`);
        return [];
    }
}

// Main execution
async function main() {
    const args = process.argv.slice(2);
    
    if (args.includes('--test')) {
        await testSingle();
    } else if (args.includes('--check')) {
        console.log('🔍 Checking existing sub-issues...\n');
        for (const parentIssue of Object.keys(SUBISSUE_MAPPINGS)) {
            await checkExistingSubIssues(parseInt(parentIssue));
        }
    } else {
        await processAllSubIssues();
    }
}

main().catch(console.error); 