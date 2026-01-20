import { useLanguage } from '@/providers/language-provider';
import { getTranslation } from '@/lib/i18n';

export function useTranslation() {
  const { language } = useLanguage();

  return (key: string, defaultValue?: string): string => {
    return getTranslation(key, language) || defaultValue || key;
  };
}
