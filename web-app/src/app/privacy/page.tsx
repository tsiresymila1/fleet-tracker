import Link from 'next/link';
import { Truck, ArrowLeft } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { getTranslations } from 'next-intl/server';

export default async function PrivacyPage() {
  const t = await getTranslations('privacy');
  
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
            {t('back')}
          </Button>
        </Link>
      </header>

      <main className="container mx-auto px-4 py-16 max-w-4xl">
        <h1 className="text-4xl md:text-5xl font-bold mb-8 tracking-tight">{t('title')}</h1>
        <div className="space-y-8 text-muted-foreground leading-relaxed text-lg">
          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">{t('intro_title')}</h2>
            <p>{t('intro_text')}</p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">{t('data_collect_title')}</h2>
            <p>{t('data_collect_text')}</p>
            <ul className="list-disc pl-6 mt-4 space-y-2">
              <li><strong className="text-foreground">{t('data_location')}:</strong> {t('data_location_desc')}</li>
              <li><strong className="text-foreground">{t('data_device')}:</strong> {t('data_device_desc')}</li>
              <li><strong className="text-foreground">{t('data_technical')}:</strong> {t('data_technical_desc')}</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">{t('usage_title')}</h2>
            <p>{t('usage_text')}</p>
            <ul className="list-disc pl-6 mt-4 space-y-2">
              <li>{t('usage_1')}</li>
              <li>{t('usage_2')}</li>
              <li>{t('usage_3')}</li>
            </ul>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">{t('security_title')}</h2>
            <p>{t('security_text')}</p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">{t('rights_title')}</h2>
            <p>
              {t.rich('rights_text', {
                 link: (chunks) => <Link href="/data-deletion" className="text-primary hover:underline">{chunks}</Link>
              })}
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-foreground mb-4">{t('updates_title')}</h2>
            <p>{t('updates_text')}</p>
            <p className="mt-4 italic">{t('last_updated')}</p>
          </section>
        </div>
      </main>

      <footer className="py-12 px-4 border-t border-border bg-background mt-20">
        <div className="container mx-auto text-center">
          <p className="text-sm text-muted-foreground">© 2026 FleetTrack Inc. Proper privacy protection for modern fleets.</p>
        </div>
      </footer>
    </div>
  );
}
