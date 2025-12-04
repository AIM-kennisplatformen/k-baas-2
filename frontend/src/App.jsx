import { useEffect, useState } from 'react'
import { atom, useAtom } from 'jotai'
import { io } from 'socket.io-client'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { ThemeSwitcher } from '@/components/ui/shadcn-io/theme-switcher'
import { useTheme } from '@/lib/theme'

// Create a Jotai atom for the count state
const countAtom = atom(0)

// Socket.IO connection
const BACKEND_URL = import.meta.env.VITE_BACKEND_URL || 'http://localhost:6616'

function App() {
  const [count, setCount] = useAtom(countAtom)
  const { theme, setTheme } = useTheme()

  // Socket.IO state
  const [socket, setSocket] = useState(null)
  const [isConnected, setIsConnected] = useState(false)
  const [messages, setMessages] = useState([])
  const [messageInput, setMessageInput] = useState('')

  useEffect(() => {
    // Create Socket.IO connection
    const newSocket = io(BACKEND_URL, {
      transports: ['websocket', 'polling']
    })

    // Connection event handlers
    newSocket.on('connect', () => {
      console.log('Connected to Socket.IO server')
      setIsConnected(true)
      setMessages(prev => [...prev, { type: 'system', text: 'Connected to server' }])
    })

    newSocket.on('disconnect', () => {
      console.log('Disconnected from Socket.IO server')
      setIsConnected(false)
      setMessages(prev => [...prev, { type: 'system', text: 'Disconnected from server' }])
    })

    newSocket.on('message', data => {
      console.log('Received message:', data)
      const messageText = data.from ? `[${data.from}]: ${data.data}` : data.data
      setMessages(prev => [...prev, { type: 'broadcast', text: messageText }])
    })

    newSocket.on('pong', data => {
      console.log('Received pong:', data)
      setMessages(prev => [...prev, { type: 'server', text: 'Pong received!' }])
    })

    setSocket(newSocket)

    // Cleanup on unmount
    return () => {
      newSocket.close()
    }
  }, [])

  const sendMessage = () => {
    if (socket && messageInput.trim()) {
      socket.emit('message', { data: messageInput })
      setMessages(prev => [...prev, { type: 'client', text: messageInput }])
      setMessageInput('')
    }
  }

  const sendPing = () => {
    if (socket) {
      socket.emit('ping')
      setMessages(prev => [...prev, { type: 'client', text: 'Ping sent' }])
    }
  }

  return (
    <>
      <div className="fixed top-4 right-4 z-50">
        <ThemeSwitcher value={theme} onChange={setTheme} />
      </div>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React + Socket.IO</h1>

      {/* Connection Status */}
      <div className="card">
        <p>
          Connection Status:{' '}
          <span style={{ color: isConnected ? 'green' : 'red' }}>
            {isConnected ? '🟢 Connected' : '🔴 Disconnected'}
          </span>
        </p>
      </div>

      {/* Counter Demo */}
      <div className="card">
        <button onClick={() => setCount(count => count + 1)}>count is {count}</button>
      </div>

      {/* Socket.IO Message Demo */}
      <div className="card" style={{ maxWidth: '600px', margin: '20px auto' }}>
        <h3>Socket.IO Demo</h3>

        <div style={{ display: 'flex', gap: '10px', marginBottom: '10px' }}>
          <input
            type="text"
            value={messageInput}
            onChange={e => setMessageInput(e.target.value)}
            onKeyPress={e => e.key === 'Enter' && sendMessage()}
            placeholder="Type a message..."
            style={{
              flex: 1,
              padding: '8px',
              borderRadius: '4px',
              border: '1px solid #646cff'
            }}
            disabled={!isConnected}
          />
          <button onClick={sendMessage} disabled={!isConnected}>
            Send
          </button>
          <button onClick={sendPing} disabled={!isConnected}>
            Ping
          </button>
        </div>

        {/* Messages Display */}
        <div
          style={{
            maxHeight: '200px',
            overflowY: 'auto',
            border: '1px solid #646cff',
            borderRadius: '4px',
            padding: '10px',
            textAlign: 'left'
          }}
        >
          {messages.map((msg, idx) => (
            <div
              key={idx}
              style={{
                marginBottom: '5px',
                color:
                  msg.type === 'system' ? '#888' : msg.type === 'client' ? '#61dafb' : '#646cff'
              }}
            >
              <strong>[{msg.type}]:</strong> {msg.text}
            </div>
          ))}
        </div>
      </div>

      <p className="read-the-docs">
        Edit <code>src/App.jsx</code> and save to test HMR
      </p>
    </>
  )
}

export default App
