import { createClient } from '@/utils/supabase/server';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Truck, Shield, Zap, MapPin, BarChart3, Globe, Download, ArrowRight } from 'lucide-react';
import { getTranslations } from 'next-intl/server';
import { ThemeToggle } from '@/components/theme-toggle';

export default async function LandingPage() {
  const supabase = await createClient();
  const t = await getTranslations();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <div className="flex flex-col min-h-screen bg-background text-foreground selection:bg-primary selection:text-primary-foreground">
      {/* Navbar */}
      <header className="px-6 lg:px-12 h-20 flex items-center border-b border-border/40 sticky top-0 bg-background/60 backdrop-blur-xl z-50">
        <Link className="flex items-center justify-center gap-3 group" href="#">
          <div className="bg-primary p-2 rounded-xl shadow-lg shadow-primary/20 group-hover:scale-110 transition-transform">
            <Truck className="h-6 w-6 text-primary-foreground" />
          </div>
          <span className="font-bold text-2xl tracking-tighter bg-clip-text text-transparent bg-gradient-to-r from-foreground to-foreground/70">FleetTrack</span>
        </Link>
        <nav className="ml-auto flex gap-6 items-center">
          <ThemeToggle />
          <Link className="hidden md:block text-sm font-medium text-muted-foreground hover:text-primary transition-colors" href="#features">
            {t('home.features')}
          </Link>
          <div className="h-4 w-px bg-border mx-2 hidden md:block" />
          
          {user ? (
            <Link href="/dashboard">
              <Button className="bg-primary hover:bg-primary/90 rounded-full px-6 h-10 text-primary-foreground font-bold shadow-xl shadow-primary/20">
                {t('home.terminal')}
              </Button>
            </Link>
          ) : (
            <div className="flex items-center gap-4">
              <Link className="hidden sm:block text-sm font-bold hover:text-primary transition-colors" href="/login">
                {t('home.login')}
              </Link>
              <Link href="/login">
                <Button className="bg-primary hover:bg-primary/90 text-primary-foreground rounded-full px-8 h-10 font-bold shadow-xl shadow-primary/20">
                  {t('home.get_started')}
                </Button>
              </Link>
            </div>
          )}
        </nav>
      </header>

      <main className="flex-1 font-outfit">
        {/* Hero Section */}
        <section className="relative w-full py-24 md:py-32 lg:py-40 px-6 overflow-hidden">
          {/* Animated Grid Background */}
          <div className="absolute inset-0 -z-10">
            <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px]"></div>
            <div className="absolute inset-0 bg-gradient-to-b from-background via-background/50 to-background"></div>
          </div>
          
          {/* Floating Elements */}
          <div className="absolute top-20 left-10 w-72 h-72 bg-primary/5 rounded-full blur-3xl animate-pulse" style={{ animationDuration: '4s' }}></div>
          <div className="absolute bottom-20 right-10 w-96 h-96 bg-blue-500/5 rounded-full blur-3xl animate-pulse" style={{ animationDuration: '6s', animationDelay: '2s' }}></div>
          
          <div className="container mx-auto relative z-10">
            <div className="flex flex-col items-center space-y-10 text-center max-w-6xl mx-auto">
              {/* Status Badge */}
              <div className="inline-flex items-center gap-2.5 rounded-full bg-primary/5 border border-primary/10 px-5 py-2 text-sm font-semibold text-primary backdrop-blur-sm">
                <span className="relative flex h-2.5 w-2.5">
                  <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75"></span>
                  <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-primary"></span>
                </span>
                <span className="tracking-wide">{t('home.intro_tag')}</span>
              </div>
              
              {/* Main Heading */}
              <div className="space-y-6">
                <h1 className="text-5xl font-extrabold tracking-tight sm:text-6xl md:text-7xl lg:text-8xl">
                  <span className="block bg-clip-text text-transparent bg-gradient-to-r from-foreground via-foreground to-foreground/70" 
                    dangerouslySetInnerHTML={{ __html: t.raw('home.title') }} />
                </h1>
                
                <p className="mx-auto max-w-3xl text-lg md:text-xl lg:text-2xl text-muted-foreground font-normal leading-relaxed">
                  {t('home.subtitle')}
                </p>
              </div>
              
              {/* CTA Buttons */}
              <div className="flex flex-col sm:flex-row gap-4 pt-4">
                <Link href={user ? "/dashboard" : "/login"}>
                  <Button size="lg" className="bg-primary hover:bg-primary/90 text-primary-foreground px-8 h-12 rounded-xl text-base font-semibold shadow-lg shadow-primary/25 hover:shadow-xl hover:shadow-primary/30 transition-all group">
                    {user ? t('home.dashboard') : t('home.get_started')}
                    <ArrowRight className="ml-2 h-5 w-5 group-hover:translate-x-0.5 transition-transform" />
                  </Button>
                </Link>
                <Link href="/setup-complete">
                  <Button size="lg" variant="outline" className="border-border hover:bg-accent px-8 h-12 rounded-xl text-base font-semibold">
                    {t('home.docs')}
                  </Button>
                </Link>
                <Link target='_blank' href="https://github.com/tsiresymila1/fleet-tracker/releases/latest">
                  <Button size="lg" variant="outline" className="border-border hover:bg-accent px-8 h-12 rounded-xl text-base font-semibold">
                    <Download className="mr-2 h-5 w-5" />
                    {t('home.app')}
                  </Button>
                </Link>
              </div>
              
              {/* Stats Bar */}
              <div className="flex flex-wrap justify-center gap-8 pt-8 text-sm">
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-green-500"></div>
                  <span className="text-muted-foreground font-medium">Real-time Tracking</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-blue-500"></div>
                  <span className="text-muted-foreground font-medium">Offline Support</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-2 h-2 rounded-full bg-purple-500"></div>
                  <span className="text-muted-foreground font-medium">Open Source</span>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Features Content */}
        <section id="features" className="w-full pb-32 px-6">
          <div className="container mx-auto">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {[
                { 
                  icon: MapPin, 
                  title: t('home.features_tracking_title'), 
                  desc: t('home.features_tracking_desc'),
                  color: 'text-primary',
                  bg: 'bg-primary/10'
                },
                { 
                  icon: Shield, 
                  title: t('home.features_no_accounts_title'), 
                  desc: t('home.features_no_accounts_desc'),
                  color: 'text-blue-500',
                  bg: 'bg-blue-500/10'
                },
                { 
                  icon: Globe, 
                  title: t('home.features_offline_title'), 
                  desc: t('home.features_offline_desc'),
                  color: 'text-emerald-500',
                  bg: 'bg-emerald-500/10'
                },
                { 
                  icon: BarChart3, 
                  title: t('home.features_analytics_title'), 
                  desc: t('home.features_analytics_desc'),
                  color: 'text-orange-500',
                  bg: 'bg-orange-500/10'
                },
                { 
                  icon: Zap, 
                  title: t('home.features_background_title'), 
                  desc: t('home.features_background_desc'),
                  color: 'text-purple-500',
                  bg: 'bg-purple-500/10'
                },
                { 
                  icon: Truck, 
                  title: t('home.features_management_title'), 
                  desc: t('home.features_management_desc'),
                  color: 'text-rose-500',
                  bg: 'bg-rose-500/10'
                }
              ].map((feature, i) => (
                <div key={i} className="group p-10 rounded-[2.5rem] bg-card/40 backdrop-blur-sm border border-border/50 hover:border-primary/30 transition-all hover:shadow-2xl hover:shadow-primary/5">
                  <div className={`p-4 rounded-2xl w-fit mb-8 ${feature.bg} group-hover:scale-110 transition-transform`}>
                    <feature.icon className={`h-8 w-8 ${feature.color}`} />
                  </div>
                  <h3 className="text-2xl font-black mb-4 tracking-tight">{feature.title}</h3>
                  <p className="text-muted-foreground leading-relaxed text-lg font-medium">{feature.desc}</p>
                </div>
              ))}
            </div>
          </div>
        </section>
      </main>

      <footer className="py-16 px-6 border-t border-border/40 dark:bg-zinc-950 bg-zinc-50 dark:text-zinc-400 text-zinc-600">
        <div className="container mx-auto">
          <div className="flex flex-col md:flex-row justify-between items-center gap-12">
            <div className="flex flex-col items-center md:items-start gap-4">
              <Link className="flex items-center gap-3" href="#">
                <div className="bg-primary p-2 rounded-xl">
                  <Truck className="h-5 w-5 text-primary-foreground" />
                </div>
                <span className="font-bold text-xl tracking-tighter dark:text-white">FleetTrack</span>
              </Link>
              <p className="text-sm text-zinc-500 max-w-xs text-center md:text-left">
                {t('footer.rights')}
              </p>
            </div>
            
            <div className="flex flex-wrap justify-center gap-10 text-sm font-bold uppercase tracking-widest">
              <Link className="hover:text-primary transition-colors" href="/privacy">{t('footer.privacy')}</Link>
              <Link className="hover:text-primary transition-colors" href="/data-deletion">{t('footer.data_deletion')}</Link>
              <Link className="hover:text-primary transition-colors" href="#">{t('footer.terms')}</Link>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
