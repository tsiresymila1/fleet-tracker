"use client";

import { useState, useEffect } from 'react';
import { createClient } from '@/utils/supabase/client';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from '@/components/ui/card';
import { User, Mail, Save, Loader2, Camera } from 'lucide-react';
import { toast } from 'sonner';
import { User as SupabaseUser } from '@supabase/supabase-js';
import Image from 'next/image';
import { useTranslations } from 'next-intl';

interface Profile {
  id: string;
  full_name?: string;
  avatar_url?: string;
  updated_at?: string;
}

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";

interface ProfileFormProps {
  user: SupabaseUser;
  profile: Profile | null;
}

export function ProfileForm({ user, profile }: ProfileFormProps) {
  const [loading, setLoading] = useState(false);
  const [fullName, setFullName] = useState('');
  const supabase = createClient();
  const t = useTranslations();

  // Update fullName when profile prop changes
  useEffect(() => {
    setFullName(profile?.full_name || '');
  }, [profile?.full_name]);

  const handleUpdateProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      // First, check if profile exists
      const { data: existingProfile, error: checkError } = await supabase
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

      if (checkError && checkError.code !== 'PGRST116') {
        // PGRST116 is "not found" which is fine
        throw checkError;
      }

      let error;
      
      if (existingProfile) {
        // Profile exists, update it
        const { error: updateError } = await supabase
          .from('profiles')
          .update({
            full_name: fullName,
            updated_at: new Date().toISOString(),
          })
          .eq('id', user.id);
        
        error = updateError;
      } else {
        // Profile doesn't exist, insert it
        // Note: This requires RLS policy to allow INSERT for authenticated users
        const { error: insertError } = await supabase
          .from('profiles')
          .insert({
            id: user.id,
            full_name: fullName,
            updated_at: new Date().toISOString(),
          });
        
        error = insertError;
        
        // If insert fails due to RLS, try using upsert with onConflict
        if (error && error.message.includes('row-level security')) {
          const { error: upsertError } = await supabase
            .from('profiles')
            .upsert({
              id: user.id,
              full_name: fullName,
              updated_at: new Date().toISOString(),
            }, {
              onConflict: 'id'
            });
          
          if (!upsertError) {
            error = null; // Success with upsert
          } else {
            error = upsertError;
          }
        }
      }

      if (error) {
        console.error('Profile update error:', error);
        throw error;
      }

      toast.success('Profile updated successfully');
      
      // Refresh the page to show updated name
      setTimeout(() => {
        window.location.reload();
      }, 500);
    } catch (error: unknown) {
      const err = error as Error;
      console.error('Profile update error:', err);
      const errorMessage = err.message || 'Failed to update profile';
      
      // Provide more helpful error message for RLS issues
      if (errorMessage.includes('row-level security') || errorMessage.includes('RLS')) {
        toast.error('Permission denied. Please ensure your database RLS policy allows profile updates.');
      } else {
        toast.error(errorMessage);
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="grid gap-6">
      <Card className="border-border bg-card/50 backdrop-blur-md">
        <CardHeader>
          <div className="flex items-center gap-2 mb-2">
            <User className="h-5 w-5 text-primary" />
            <CardTitle>{t('account.profileSettings')}</CardTitle>
          </div>
          <CardDescription>{t('account.profileDescription')}</CardDescription>
        </CardHeader>
        <form onSubmit={handleUpdateProfile}>
          <CardContent className="space-y-6">
            <div className="flex flex-col md:flex-row gap-8 items-start">
              <div className="relative group">
                <div className="w-24 h-24 rounded-full bg-muted border-2 border-border flex items-center justify-center overflow-hidden relative">
                  {profile?.avatar_url ? (
                    <Image 
                      src={profile.avatar_url} 
                      alt="Avatar" 
                      fill
                      className="object-cover" 
                    />
                  ) : (
                    <User className="h-10 w-10 text-muted-foreground" />
                  )}
                </div>
                <button type="button" className="absolute bottom-0 right-0 bg-primary p-1.5 rounded-full border-2 border-background text-primary-foreground opacity-0 group-hover:opacity-100 transition-opacity">
                  <Camera className="h-3.5 w-3.5" />
                </button>
              </div>

              <div className="flex-1 space-y-4 w-full">
                <div className="space-y-2">
                  <Label htmlFor="email" className="text-muted-foreground text-sm">{t('account.email')}</Label>
                  <div className="relative">
                    <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input 
                      id="email" 
                      value={user.email || ''} 
                      disabled 
                      className="bg-muted/50 border-input pl-10 text-muted-foreground" 
                    />
                  </div>
                  <p className="text-[10px] text-muted-foreground italic">{t('account.emailNote')}</p>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="full-name" className="text-muted-foreground text-sm">{t('account.fullName')}</Label>
                  <Input 
                    id="full-name" 
                    value={fullName}
                    onChange={(e) => setFullName(e.target.value)}
                    placeholder="e.g. John Doe"
                    className="bg-background border-input focus:ring-primary/20 py-6"
                  />
                </div>
              </div>
            </div>
          </CardContent>
          <CardFooter className="border-t border-border pt-6">
            <Button 
              type="submit" 
              disabled={loading}
              className="bg-primary hover:bg-primary/90 text-white shadow-lg shadow-primary/20 px-8 rounded-sm ml-auto"
            >
              {loading ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : <Save className="h-4 w-4 mr-2" />}
              {t('account.save')}
            </Button>
          </CardFooter>
        </form>
      </Card>

      <Card className="border-destructive/20 bg-card/50">
        <CardHeader>
          <CardTitle className="text-destructive">{t('account.securityZone')}</CardTitle>
          <CardDescription>{t('account.securityDescription')}</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between p-4 rounded-xl bg-muted/30 border border-border">
            <div>
              <p className="text-sm font-bold text-foreground">{t('account.changePassword')}</p>
              <p className="text-xs text-muted-foreground">{t('account.passwordResetDescription')}</p>
            </div>
            
            <AlertDialog>
              <AlertDialogTrigger asChild>
                <Button variant="outline" className="border-input hover:bg-muted hover:text-foreground">{t('account.requestReset')}</Button>
              </AlertDialogTrigger>
              <AlertDialogContent>
                <AlertDialogHeader>
                  <AlertDialogTitle>{t('account.resetConfirmTitle')}</AlertDialogTitle>
                  <AlertDialogDescription>
                    {t.rich('account.resetConfirmMessage', { 
                      email: user.email || '', 
                      bold: (chunks) => <strong className="text-foreground">{chunks}</strong> 
                    })}
                  </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                  <AlertDialogCancel>{t('common.cancel')}</AlertDialogCancel>
                  <AlertDialogAction onClick={async () => {
                    const { error } = await supabase.auth.resetPasswordForEmail(user.email!);
                    if (error) toast.error(error.message);
                    else toast.success("Reset link sent to your email!");
                  }}>
                    {t('account.sendEmail')}
                  </AlertDialogAction>
                </AlertDialogFooter>
              </AlertDialogContent>
            </AlertDialog>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
