"use client";

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger
} from '@/components/ui/alert-dialog';
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
} from '@/components/ui/sidebar';
import { createClient } from '@/utils/supabase/client';
import { User as SupabaseUser } from '@supabase/supabase-js';
import {
  History,
  LayoutDashboard,
  LogOut,
  Moon,
  Radio,
  Sun,
  Truck,
  User
} from 'lucide-react';
import { useTheme } from 'next-themes';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import { toast } from 'sonner';
import { LanguageSwitcher } from './language-switcher';
import { useTranslations } from 'next-intl';

const navItemsConfig = [
  { key: 'nav.dashboard', url: "/dashboard", icon: LayoutDashboard },
  { key: 'nav.tracking', url: "/dashboard/tracking", icon: Radio },
  { key: 'nav.devices', url: "/dashboard/devices", icon: Truck },
  { key: 'nav.history', url: "/dashboard/history", icon: History },
];

export function DashboardSidebar() {
  const pathname = usePathname();
  const router = useRouter();
  const { theme, setTheme } = useTheme();
  const supabase = createClient();
  const t = useTranslations();
  const [user, setUser] = useState<SupabaseUser | null>(null);

  useEffect(() => {
    const getUser = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      setUser(user);
    };
    getUser();
  }, [supabase.auth]);

  const handleSignOut = async () => {
    const { error } = await supabase.auth.signOut();
    if (error) {
      toast.error(error.message);
    } else {
      toast.success(t('common.success'));
      router.push('/login');
      router.refresh();
    }
  };

  return (
    <Sidebar variant="inset" className="border-r dark:border-zinc-900 dark:bg-zinc-950">
      <SidebarHeader className="flex items-center justify-center py-10 border-b border-zinc-100/5 mx-4">
        <div className="flex items-center gap-3">
          <div className="bg-primary p-2.5 rounded-xl shadow-lg shadow-primary/20">
            <Truck className="w-6 h-6 text-white" />
          </div>
          <span className="font-extrabold text-2xl tracking-tighter dark:text-white text-primary">FleetTrack</span>
        </div>
      </SidebarHeader>

      <SidebarContent className="px-2 mt-6">
        <SidebarGroup>
          <SidebarGroupLabel className="text-zinc-700 dark:text-zinc-400 font-bold text-[10px] uppercase tracking-widest px-4 mb-2">Platform</SidebarGroupLabel>
          <SidebarGroupContent>
            <SidebarMenu className="gap-1">
              {navItemsConfig.map((item) => {
                const isActive = pathname === item.url || (item.url !== "/dashboard" && pathname.startsWith(item.url));
                return (
                  <SidebarMenuItem key={item.url}>
                    <SidebarMenuButton 
                      asChild 
                      tooltip={t(item.key)}
                      isActive={isActive}
                      className={`
                        flex items-center gap-3 px-4 py-6 rounded-xl transition-all duration-200
                        ${isActive 
                          ? 'bg-primary/10 dark:bg-primary/10 text-primary dark:text-primary font-semibold' 
                          : 'text-zinc-700 dark:text-zinc-300 hover:text-primary hover:bg-primary/10 dark:hover:text-zinc-100 dark:hover:bg-primary/10'}
                      `}
                    >
                      <Link href={item.url}>
                        <item.icon className={`w-5 h-5 ${isActive ? 'text-primary' : 'text-zinc-500'}`} />
                        <span>{t(item.key)}</span>
                      </Link>
                    </SidebarMenuButton>
                  </SidebarMenuItem>
                );
              })}
            </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>

        <SidebarGroup className="mt-4">
          <SidebarGroupLabel className="text-zinc-700 dark:text-zinc-400 font-bold text-[10px] uppercase tracking-widest px-4 mb-2">Preferences</SidebarGroupLabel>
          <SidebarGroupContent>
             <SidebarMenu className="gap-1">
                <SidebarMenuItem>
                    <SidebarMenuButton 
                      onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
                      className="flex items-center gap-3 px-4 py-6 rounded-xl dark:text-zinc-300 text-zinc-700 hover:text-primary hover:bg-primary/10 dark:hover:text-zinc-100 transition-all"
                    >
                        {theme === 'dark' ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
                        <span>{theme === 'dark' ? t('nav.light_mode') : t('nav.dark_mode')}</span>
                    </SidebarMenuButton>
                </SidebarMenuItem>
                <SidebarMenuItem>
                    <LanguageSwitcher />
                </SidebarMenuItem>
             </SidebarMenu>
          </SidebarGroupContent>
        </SidebarGroup>
      </SidebarContent>

      <SidebarFooter className="p-4 border-t border-zinc-100/5">
         <SidebarMenu>
            {user && (
                <SidebarMenuItem>
                    <SidebarMenuButton asChild className="mb-2 py-8 px-4 rounded-xl hover:bg-primary/20 transition-colors group">
                        <Link href="/dashboard/account" className="flex items-center gap-3 w-full">
                            <div className="h-9 w-9 rounded-full bg-primary/10 border border-primary/20 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-primary-foreground transition-colors">
                                <User className="h-4 w-4" />
                            </div>
                            <div className="flex flex-col min-w-0">
                                <span className="text-sm font-bold text-zinc-700 dark:text-zinc-100 truncate">{t('nav.account')}</span>
                                <span className="text-[10px] text-zinc-500 truncate">{user.email}</span>
                            </div>
                        </Link>
                    </SidebarMenuButton>
                </SidebarMenuItem>
            )}
            <SidebarMenuItem>
                <AlertDialog>
                    <AlertDialogTrigger asChild>
                        <SidebarMenuButton 
                          className="w-full justify-start dark:text-zinc-500 text-zinc-500 dark:hover:text-red-500 hover:bg-red-500/10 hover:text-red-500 dark:hover:bg-red-500/10 rounded-xl py-6 px-4 transition-colors"
                        >
                            <LogOut className="w-5 h-5 mr-3" />
                            <span className="font-medium">{t('nav.sign_out')}</span>
                        </SidebarMenuButton>
                    </AlertDialogTrigger>
                    <AlertDialogContent className="dark:bg-zinc-950 dark:border-zinc-900 font-outfit">
                        <AlertDialogHeader>
                            <AlertDialogTitle className="dark:text-zinc-100">{t('common.confirmDelete')}</AlertDialogTitle>
                            <AlertDialogDescription className="text-zinc-500">
                                Are you sure you want to end your current session? You will need to re-authenticate to access the fleet terminal.
                            </AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                            <AlertDialogCancel className="dark:bg-zinc-900 dark:border-zinc-800 dark:text-zinc-300">{t('common.cancel')}</AlertDialogCancel>
                            <AlertDialogAction 
                                onClick={handleSignOut}
                                className="bg-red-600 hover:bg-red-700 text-white"
                            >
                                {t('nav.sign_out')}
                            </AlertDialogAction>
                        </AlertDialogFooter>
                    </AlertDialogContent>
                </AlertDialog>
            </SidebarMenuItem>
         </SidebarMenu>
      </SidebarFooter>
    </Sidebar>
  );
}
