'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { AlertTriangle, Loader2 } from 'lucide-react';
import { toast } from 'sonner';
import { submitDeletionRequest } from '@/app/actions/deletion-actions';
import { useTranslations } from 'next-intl';

export function DeletionRequestForm() {
  const t = useTranslations('deletion');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (formData: FormData) => {
    setLoading(true);
    try {
      const result = await submitDeletionRequest(formData);
      
      if (result?.error) {
        toast.error(result.error);
      } else {
        toast.success('Deletion request submitted successfully');
        // Optional: Reset form or show success state
        (document.getElementById('deletion-form') as HTMLFormElement)?.reset();
      }
    } catch {
      toast.error('Something went wrong');
    } finally {
      setLoading(false);
    }
  };

  return (
    <form id="deletion-form" action={handleSubmit} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="deviceId">{t('device_id')}</Label>
        <Input 
          id="deviceId" 
          name="deviceId"
          placeholder={t('device_id_placeholder')}
          className="bg-background border-input"
          required
        />
        <p className="text-xs text-muted-foreground flex items-center gap-1">
          <AlertTriangle className="w-3 h-3" />
          {t('device_id_help')}
        </p>
      </div>

      <div className="space-y-2">
        <Label htmlFor="reason">{t('reason')}</Label>
        <Textarea 
          id="reason" 
          name="reason"
          placeholder={t('reason_placeholder')}
          className="bg-background border-input min-h-[100px]"
        />
      </div>
      
      <Button 
        type="submit" 
        disabled={loading}
        className="w-full bg-destructive hover:bg-destructive/90 text-destructive-foreground font-bold py-6 rounded-xl"
      >
        {loading ? <Loader2 className="w-5 h-5 animate-spin" /> : t('submit')}
      </Button>
    </form>
  );
}
