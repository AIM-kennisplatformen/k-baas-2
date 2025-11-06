import { atom, useAtom } from 'jotai'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import { ThemeSwitcher } from '@/components/ui/shadcn-io/theme-switcher'
import { useTheme } from '@/lib/theme'

// Create a Jotai atom for the count state
const countAtom = atom(0)

function App() {
  const [count, setCount] = useAtom(countAtom)
  const { theme, setTheme } = useTheme()

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
      <h1>Vite + React + Jotai</h1>
      <div className="card">
        <button onClick={() => setCount(count => count + 1)}>count is {count}</button>
        <p>
          Edit <code>src/App.jsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">Click on the Vite and React logos to learn more</p>
      <p className="read-the-docs">Now using Jotai for state management! 🎉</p>
    </>
  )
}

export default App
