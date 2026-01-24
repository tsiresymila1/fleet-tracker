"use client"

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/utils/supabase/client'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Truck, Mail, Lock, Loader2, Zap, User } from 'lucide-react'
import { toast } from 'sonner'
import Link from 'next/link'
import { AuthError } from '@supabase/supabase-js'
import { useTranslations } from 'next-intl';
import { ThemeToggle } from '@/components/theme-toggle'

export default function LoginPage() {
  const t = useTranslations('auth');
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [isSignUp, setIsSignUp] = useState(false)
  const router = useRouter()
  const supabase = createClient()

  const handleAuth = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)

    try {
      if (isSignUp) {
        const { error } = await supabase.auth.signUp({
          email,
          password,
          options: {
            emailRedirectTo: `${window.location.origin}/auth/callback`,
            data: {
              full_name: name,
            }
          },
        })
        if (error) throw error
        toast.success(t('registration_success'))
      } else {
        const { error } = await supabase.auth.signInWithPassword({
          email,
          password,
        })
        if (error) throw error
        toast.success(t('login_success'))
        router.push('/dashboard')
        router.refresh()
      }
    } catch (error: unknown) {
      const authError = error as AuthError
      toast.error(authError.message || t('auth_failed'))
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex bg-background font-outfit text-foreground">
      <div className="absolute top-4 right-4 z-50">
        <ThemeToggle />
      </div>
      {/* Left Side: Minimalist Branding */}
      <div className="hidden lg:flex lg:w-1/2 relative overflow-hidden flex-col justify-center p-20 bg-zinc-50 dark:bg-zinc-950 border-r border-border transition-colors duration-500">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_50%,rgba(var(--primary-rgb),0.1),transparent)] z-0" />
        
        <div className="relative z-10 max-w-lg mx-auto text-center space-y-8">
          <Link className="flex items-center justify-center gap-4 mb-12" href="/">
            <div className="bg-primary p-3 rounded-2xl shadow-2xl shadow-primary/20">
              <Truck className="h-8 w-8 text-primary-foreground" />
            </div>
            <span className="font-bold text-4xl tracking-tighter text-foreground">FleetTrack</span>
          </Link>
          
          <h1 className="text-5xl lg:text-6xl font-bold tracking-tighter leading-tight text-foreground" dangerouslySetInnerHTML={{ __html: t.raw('hero_title') }} />
          <p className="text-xl text-zinc-400 leading-relaxed">
            {t('hero_desc')}
          </p>
          
          <div className="pt-12 grid grid-cols-2 gap-4 opacity-50">
            <div className="px-4 py-2 border border-zinc-800 rounded-full text-[10px] text-zinc-500 uppercase tracking-widest font-bold">
              {t('secure_uplink')}
            </div>
            <div className="px-4 py-2 border border-zinc-800 rounded-full text-[10px] text-zinc-500 uppercase tracking-widest font-bold">
              {t('global_relay')}
            </div>
          </div>
        </div>
      </div>

      {/* Right Side: Auth Form */}
      <div className="flex-1 lg:w-1/2 flex items-center justify-center p-8 lg:p-24 relative overflow-hidden">
        {/* Background Glow for Mobile */}
        <div className="lg:hidden absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[400px] h-[400px] bg-primary/10 blur-[100px] rounded-full -z-10" />
        
        <div className="w-full max-w-[440px] space-y-8 relative z-10">
          <div className="lg:hidden flex items-center justify-center gap-3 mb-12">
            <div className="bg-primary p-2 rounded-xl">
              <Truck className="h-5 w-5 text-primary-foreground" />
            </div>
            <span className="font-bold text-2xl tracking-tighter text-foreground">FleetTrack</span>
          </div>

          <div className="space-y-2 text-center">
            <h2 className="text-4xl font-bold tracking-tight text-foreground">
              {isSignUp ? t('initiate') : t('welcome')}
            </h2>
            <p className="text-muted-foreground">
              {isSignUp 
                ? t('register_desc') 
                : t('access_desc')
              }
            </p>
          </div>

          <div className="bg-card/40 backdrop-blur-xl border border-border rounded-xl p-8 shadow-2xl">
            <form onSubmit={handleAuth} className="space-y-6">
              <div className="space-y-4">
                {isSignUp && (
                  <div className="space-y-2">
                    <Label htmlFor="name" className="text-foreground text-xs font-bold uppercase tracking-wider">{t('full_name')}</Label>
                    <div className="relative group">
                      <User className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
                      <Input 
                        id="name" 
                        type="text" 
                        placeholder={t('fullNamePlaceholder')}
                        required 
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        className="bg-background/30 border-input pl-11 focus:border-primary/50 focus:ring-primary/10 text-foreground"
                      />
                    </div>
                  </div>
                )}
                <div className="space-y-2">
                  <Label htmlFor="email" className="text-muted-foreground text-xs font-bold uppercase tracking-wider">{t('email_auth')}</Label>
                  <div className="relative group">
                    <Mail className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
                    <Input 
                      id="email" 
                      type="email" 
                      placeholder="admin@organization.io" 
                      required 
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="bg-background/30 border-input pl-11 focus:border-primary/50 focus:ring-primary/10 text-foreground"
                    />
                  </div>
                </div>
                <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <Label htmlFor="password" className="text-muted-foreground text-xs font-bold uppercase tracking-wider">{t('password')}</Label>
                    {!isSignUp && (
                      <Link href="#" className="text-xs text-primary hover:text-primary/80 font-medium transition-colors">
                        {t('forgot_password')}
                      </Link>
                    )}
                  </div>
                  <div className="relative group">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground group-focus-within:text-primary transition-colors" />
                    <Input 
                      id="password" 
                      type="password" 
                      placeholder='********'
                      required 
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      className="bg-background/30 border-input pl-11 focus:border-primary/50 focus:ring-primary/10 text-foreground"
                    />
                  </div>
                </div>
              </div>

              <Button 
                type="submit" 
                disabled={loading}
                className="w-full bg-primary hover:bg-primary/90 text-white font-bold shadow-xl shadow-primary/20 group overflow-hidden relative"
              >
                {loading ? (
                  <Loader2 className="h-5 w-5 animate-spin" />
                ) : (
                  <span className="flex items-center gap-2 text-white">
                    {isSignUp ? t('register_btn') : t('login_btn')}
                    <Zap className="h-4 w-4" />
                  </span>
                )}
              </Button>
            </form>
          </div>

          <div className="text-center space-y-4">
            <p className="text-sm text-muted-foreground">
              {isSignUp 
                ? t('already_node') 
                : t('new_org')
              }
              {' '}
              <button
                type="button"
                onClick={() => setIsSignUp(!isSignUp)}
                className="text-primary hover:text-primary/80 font-bold transition-colors underline decoration-primary/30 hover:decoration-primary underline-offset-4"
              >
                {isSignUp ? t('authorize') : t('register_subsystem')}
              </button>
            </p>
            
            <p className="text-[10px] text-muted-foreground mx-auto max-w-[300px] lg:max-w-none leading-relaxed" dangerouslySetInnerHTML={{ __html: t.raw('agreement') }} />
          </div>
        </div>
      </div>
    </div>
  )
}
