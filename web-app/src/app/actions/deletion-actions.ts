'use server'

import { createClient } from '@/utils/supabase/server';
import { revalidatePath } from 'next/cache';

export async function submitDeletionRequest(formData: FormData) {
  const supabase = await createClient();
  const deviceId = formData.get('deviceId') as string;
  const reason = formData.get('reason') as string;

  if (!deviceId) {
    return { error: 'Device ID is required' };
  }

  try {
    const { error } = await supabase
      .from('deletion_requests')
      .insert({
        device_id: deviceId,
        reason: reason,
        status: 'pending'
      });

    if (error) {
      console.error('Error submitting deletion request:', error);
      return { error: 'Failed to submit request' };
    }

    revalidatePath('/data-deletion');
    return { success: true };
  } catch (err) {
    console.error('Unexpected error:', err);
    return { error: 'Internal server error' };
  }
}
