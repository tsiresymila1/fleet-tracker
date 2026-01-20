import { createClient } from '@/utils/supabase/server';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Truck, Shield, Zap, MapPin, BarChart3, Globe, Download } from 'lucide-react';
import { getTranslations } from 'next-intl/server';

export default async function LandingPage() {
  const supabase = await createClient();
  const t = await getTranslations();
  const { data: { user } } = await supabase.auth.getUser();

  return (
    <div className="flex flex-col min-h-screen bg-background text-foreground">
      {/* Navbar */}
      <header className="px-4 lg:px-6 h-20 flex items-center border-b border-border sticky top-0 bg-background/50 backdrop-blur-md z-50">
        <Link className="flex items-center justify-center gap-2" href="#">
          <div className="bg-primary p-2 rounded-lg">
            <Truck className="h-6 w-6 text-primary-foreground" />
          </div>
          <span className="font-bold text-2xl tracking-tighter">FleetTrack</span>
        </Link>
        <nav className="ml-auto flex gap-4 sm:gap-6 items-center">
          <Link className="text-sm font-medium hover:text-primary transition-colors" href="#features">
            {t('home.features')}
          </Link>
          {user ? (
            <Link href="/dashboard">
              <Button className="bg-primary hover:bg-primary/90 rounded-md px-6 text-primary-foreground">
                {t('home.terminal')}
              </Button>
            </Link>
          ) : (
            <>
              <Link className="text-sm font-medium hover:text-primary transition-colors" href="/login">
                {t('home.login')}
              </Link>
              <Link href="/login">
                <Button className="bg-primary hover:bg-primary/90 text-white rounded-md px-6">
                  {t('home.get_started')}
                </Button>
              </Link>
            </>
          )}
        </nav>
      </header>

      <main className="flex-1 font-outfit ">
        {/* Hero Section */}
        <section className="w-full py-12 md:py-24 lg:py-32 xl:py-48 px-4 overflow-hidden relative ">
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[400px] bg-primary/20 blur-[120px] rounded-full -z-10" />
          <div className="container mx-auto">
            <div className="flex flex-col items-center space-y-8 text-center">
              <div className="space-y-4 max-w-3xl">
                <div className="inline-block rounded-full bg-primary/10 px-3 py-1 text-sm font-medium text-primary border border-primary/20 mb-4">
                  {t('home.intro_tag')}
                </div>
                <h1 className="text-5xl font-bold tracking-tighter sm:text-6xl md:text-7xl lg:text-8xl" dangerouslySetInnerHTML={{ __html: t.raw('home.title') }} />

                <p className="mx-auto max-w-[700px] text-muted-foreground md:text-xl/relaxed lg:text-2xl/relaxed">
                  {t('home.subtitle')}
                </p>
              </div>
              <div className="flex flex-col sm:flex-row gap-4">
                <Link href={user ? "/dashboard" : "/login"}>
                  <Button size="lg" className="bg-primary hover:bg-primary/90 text-white px-8 rounded-md group">
                    {user ? t('home.dashboard') : t('home.get_started')}
                    <Zap className="ml-2 h-5 w-5 group-hover:scale-125 transition-transform" />
                  </Button>
                </Link>
                <Link href="/setup-complete">
                  <Button size="lg" variant="outline" className="border-border text-foreground hover:bg-accent px-8 rounded-md">
                    {t('home.docs')}
                  </Button>
                </Link>
                <Link target='_blank' href="https://github.com/tsiresymila1/fleet-tracker/releases/latest">
                  <Button size="lg" variant="default" className="border-border text-foreground hover:bg-accent px-8 rounded-md">
                    <Download className="ml-2 h-5 w-5 group-hover:scale-125 transition-transform" />
                    {t('home.app')}
                  </Button>
                </Link>
              </div>
            </div>
          </div>
        </section>

        {/* Features Grid */}
        <section id="features" className="w-full pb-24">
          <div className="container mx-auto px-4">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {[
                { 
                  icon: MapPin, 
                  title: t('home.features_tracking_title'), 
                  desc: t('home.features_tracking_desc') 
                },
                { 
                  icon: Shield, 
                  title: t('home.features_no_accounts_title'), 
                  desc: t('home.features_no_accounts_desc') 
                },
                { 
                  icon: Globe, 
                  title: t('home.features_offline_title'), 
                  desc: t('home.features_offline_desc') 
                },
                { 
                  icon: BarChart3, 
                  title: t('home.features_analytics_title'), 
                  desc: t('home.features_analytics_desc') 
                },
                { 
                  icon: Zap, 
                  title: t('home.features_background_title'), 
                  desc: t('home.features_background_desc') 
                },
                { 
                  icon: Truck, 
                  title: t('home.features_management_title'), 
                  desc: t('home.features_management_desc') 
                }
              ].map((feature, i) => (
                <div key={i} className="group p-8 rounded-3xl bg-primary/5 border border-border hover:border-primary/50 transition-all">
                  <div className="bg-primary/20 p-3 rounded-2xl w-fit mb-6 group-hover:bg-primary transition-colors">
                    <feature.icon className="h-6 w-6 text-foreground group-hover:text-primary-foreground" />
                  </div>
                  <h3 className="text-xl font-bold mb-3">{feature.title}</h3>
                  <p className="text-muted-foreground leading-relaxed">{feature.desc}</p>
                </div>
              ))}
            </div>
          </div>
        </section>
      </main>

      <footer className="py-12 px-4 border-t border-border bg-card">
        <div className="container mx-auto flex flex-col md:flex-row justify-between items-center gap-6">
          <div className="flex items-center gap-2">
            <Truck className="h-5 w-5 text-primary" />
            <span className="font-bold text-lg">FleetTrack</span>
          </div>
          <p className="text-sm text-muted-foreground">{t('footer.rights')}</p>
          <div className="flex gap-6">
            <Link className="text-sm text-muted-foreground hover:text-foreground" href="/privacy">{t('footer.privacy')}</Link>
            <Link className="text-sm text-muted-foreground hover:text-foreground" href="/data-deletion">{t('footer.data_deletion')}</Link>
            <Link className="text-sm text-muted-foreground hover:text-foreground" href="#">{t('footer.terms')}</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
