import { useAtom } from 'jotai'
import { atomWithStorage } from 'jotai/utils'

// Helper to get system theme preference
const getSystemTheme = () => {
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
}

// Helper to apply theme to document
const applyTheme = themeValue => {
  const effectiveTheme = themeValue === 'system' ? getSystemTheme() : themeValue
  document.documentElement.classList.remove('light', 'dark')
  document.documentElement.classList.add(effectiveTheme)
}

// Create theme atom with localStorage persistence
export const themeAtom = atomWithStorage('theme', 'system', {
  getItem: key => {
    const value = localStorage.getItem(key)
    return value || 'system'
  },
  setItem: (key, value) => {
    localStorage.setItem(key, value)
    applyTheme(value)
  },
  removeItem: key => {
    localStorage.removeItem(key)
  }
})

// Initialize theme on module load
const savedTheme = localStorage.getItem('theme') || 'system'
applyTheme(savedTheme)

// Listen for system theme changes
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
  const currentTheme = localStorage.getItem('theme') || 'system'
  if (currentTheme === 'system') {
    applyTheme('system')
  }
})

// Custom hook for theme management
export function useTheme() {
  const [theme, setTheme] = useAtom(themeAtom)

  return {
    theme,
    setTheme
  }
}
