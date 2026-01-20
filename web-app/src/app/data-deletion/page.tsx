import { Button } from '@/components/ui/button';
import { ArrowLeft, Mail, ShieldAlert, Trash2, Truck } from 'lucide-react';
import { getTranslations } from 'next-intl/server';
import Link from 'next/link';

import { DeletionRequestForm } from '@/components/deletion-request-form';

export default async function DataDeletionPage() {
  const t = await getTranslations();
  
  return (
    <div className="min-h-screen bg-background text-foreground font-outfit">

      <header className="px-4 lg:px-6 h-20 flex items-center border-b border-border sticky top-0 bg-background/50 backdrop-blur-md z-50">
        <Link className="flex items-center justify-center gap-2" href="/">
          <div className="bg-primary p-2 rounded-lg">
            <Truck className="h-6 w-6 text-primary-foreground" />
          </div>
          <span className="font-bold text-2xl tracking-tighter">FleetTrack</span>
        </Link>
        <Link href="/" className="ml-auto">
          <Button variant="ghost" className="text-muted-foreground hover:text-foreground">
            <ArrowLeft className="mr-2 h-4 w-4" />
            {t('privacy.back')}
          </Button>
        </Link>
      </header>

      <main className="container mx-auto px-4 py-16 max-w-4xl">
        <div className="text-center mb-12">
          <div className="bg-destructive/10 p-4 rounded-full w-fit mx-auto mb-6">
            <Trash2 className="h-10 w-10 text-destructive" />
          </div>
          <h1 className="text-4xl md:text-5xl font-bold mb-4 tracking-tight">{t('deletion.title')}</h1>
          <p className="text-muted-foreground text-lg max-w-2xl mx-auto">
            {t('deletion.subtitle')}
          </p>
        </div>

        <div className="grid gap-8">
          {/* Automatic Deletion Info */}
          <div className="bg-card border border-border p-8 rounded-2xl relative overflow-hidden shadow-sm">
            <div className="absolute top-0 right-0 p-4 opacity-10">
              <ShieldAlert className="w-24 h-24 text-primary" />
            </div>
            
            <div className="relative z-10 space-y-4">
              <div className="bg-primary/10 w-fit p-3 rounded-xl mb-4">
                <Trash2 className="w-6 h-6 text-primary" />
              </div>
              <h2 className="text-2xl font-bold">{t('deletion.auto_title')}</h2>
              <p className="text-muted-foreground">
                {t('deletion.auto_desc')}
              </p>
              
              <div className="bg-primary/50 p-4 rounded-lg border border-border mt-6">
                <p className="text-sm text-secondary-foreground leading-relaxed" dangerouslySetInnerHTML={{ __html: t.raw('deletion.auto_text') }} />
              </div>
            </div>
          </div>

          {/* Manual Request Form */}
          <div className="bg-card border border-border p-8 rounded-2xl shadow-sm">
            <div className="space-y-6">
              <div>
                <h2 className="text-2xl font-bold mb-2">{t('deletion.manual_title')}</h2>
                <p className="text-muted-foreground text-sm">{t('deletion.manual_desc')}</p>
              </div>

              <DeletionRequestForm />
            </div>
          </div>

          <div className="flex items-center gap-4 p-6 rounded-2xl bg-muted/30 border border-border">
            <div className="bg-muted p-3 rounded-xl text-muted-foreground">
              <Mail className="h-6 w-6" />
            </div>
            <div>
              <p className="font-medium text-foreground">{t('deletion.help')}</p> 
              <p className="text-sm text-muted-foreground" dangerouslySetInnerHTML={{ __html: t.raw('deletion.contact') }} />
            </div>
          </div>
        </div>
      </main>

      <footer className="py-12 px-4 border-t border-border bg-background mt-20">
        <div className="container mx-auto text-center">
          <p className="text-sm text-muted-foreground">{t('footer.copyright')}</p>
        </div>
      </footer>
    </div>
  );
}
