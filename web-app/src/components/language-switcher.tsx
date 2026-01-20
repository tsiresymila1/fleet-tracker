'use client';

import { useLocale, useTranslations } from 'next-intl';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Globe } from 'lucide-react';
import { SidebarMenuButton } from '@/components/ui/sidebar';
import { useRouter } from 'next/navigation';
import { useCallback } from 'react';

const LANGUAGES = {
  en: 'English',
  fr: 'Français'
};

export function LanguageSwitcher() {
  const locale = useLocale();
  const t = useTranslations('common');
  const router = useRouter();

  const handleLanguageChange = useCallback((newLocale: string) => {
    // Set cookie for language preference
    document.cookie = `NEXT_LOCALE=${newLocale}; path=/; max-age=31536000`;
    // Refresh page to apply locale
    router.refresh();
  }, [router]);

  return (
    <SidebarMenuButton 
      className="flex items-center gap-3 px-4 py-6 rounded-xl dark:text-zinc-300 text-zinc-700 hover:text-primary hover:bg-primary/10 dark:hover:text-zinc-100 transition-all"
    >
      <div className="flex items-center gap-3 w-full">
        <Globe className="h-5 w-5" />
        <Select value={locale} onValueChange={handleLanguageChange}>
          <SelectTrigger className="w-full border-0 bg-transparent focus:ring-0 p-0 h-auto px-4">
            <SelectValue />
          </SelectTrigger>
          <SelectContent className="dark:bg-zinc-900 dark:border-zinc-800">
            {Object.entries(LANGUAGES).map(([code, name]) => (
              <SelectItem key={code} value={code} className='px-4'>
                {name}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
    </SidebarMenuButton>
  );
}
