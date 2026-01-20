import { createClient } from '@/utils/supabase/server';
import { redirect } from 'next/navigation';
import { ProfileForm } from './profile-form';
import { getTranslations } from 'next-intl/server';

export default async function AccountPage() {
  const supabase = await createClient();
  const t = await getTranslations();

  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    redirect('/login');
  }

  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .maybeSingle();

  return (
    <div className="space-y-6 max-w-4xl mx-auto pb-20">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">{t('account.title')}</h1>
        <p className="text-muted-foreground">{t('account.subtitle')}</p>
      </div>

      <ProfileForm user={user} profile={profile} />
    </div>
  );
}
