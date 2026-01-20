"use client";

import { SidebarProvider, SidebarInset, SidebarTrigger } from "@/components/ui/sidebar";
import { DashboardSidebar } from "@/components/dashboard-sidebar";
import { usePathname } from "next/navigation";
import { Search, Bell, HelpCircle, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import Link from 'next/link';
import { LogoutButton } from "./logout-button";
import { useEffect, useState } from "react";
import { createClient } from "@/utils/supabase/client";
import { useTranslations } from "next-intl";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const [userInitials, setUserInitials] = useState("JD");
  const supabase = createClient();

  useEffect(() => {
    const fetchUserProfile = async () => {
      const { data: { user } } = await supabase.auth.getUser();
      if (user) {
        const { data: profile } = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

        if (profile?.full_name) {
          // Get initials from full name
          const names = profile.full_name.trim().split(' ');
          if (names.length >= 2) {
            setUserInitials((names[0][0] + names[names.length - 1][0]).toUpperCase());
          } else if (names.length === 1) {
            setUserInitials(names[0].substring(0, 2).toUpperCase());
          }
        } else if (user.email) {
          // Fallback to email initials
          const emailParts = user.email.split('@')[0];
          setUserInitials(emailParts.substring(0, 2).toUpperCase());
        }
      }
    };

    fetchUserProfile();
  }, [supabase]);

  const t = useTranslations('nav');
  const tCommon = useTranslations('common');
  const getPageTitle = (path: string) => {
    if (path.includes("/tracking")) return t('tracking');
    if (path.includes("/devices")) return t('devices');
    if (path.includes("/history")) return t('history');
    if (path.includes("/settings")) return t('preferences');
    return t('dashboard');
  };

  return (
    <SidebarProvider>
      <DashboardSidebar />
      <SidebarInset className="bg-background flex flex-col">
        <header className="flex h-16 shrink-0 items-center justify-between gap-2 border-b border-border bg-background px-6 sticky top-0 z-50 transition-[width,height] ease-linear">
            <div className="flex items-center gap-2">
                <SidebarTrigger className="hover:bg-zinc-900 transition-colors" />
                <div className="h-4 w-px bg-zinc-800 mx-3" />
                <h1 className="text-sm font-semibold dark:text-zinc-200 text-zinc-500 tracking-tight">{getPageTitle(pathname)}</h1>
            </div>
            <div className="flex items-center gap-2">
                <div className="hidden md:flex items-center dark:bg-zinc-900/50 border dark:border-zinc-800 rounded-lg px-3 py-1.5 mr-4 w-64 group focus-within:border-primary/50 transition-all">
                  <Search className="h-4 w-4 text-zinc-500 group-focus-within:text-primary mr-2" />
                  <input placeholder={tCommon('searchEverywhere')} className="bg-transparent border-none text-xs focus:ring-0 w-full placeholder:text-zinc-600 outline-none" />
                  <span className="text-[10px] text-zinc-700 font-mono">⌘K</span>
                </div>
                <Button variant="ghost" size="icon" className="text-zinc-400 hover:text-white hover:bg-primary h-9 w-9">
                  <HelpCircle className="h-4 w-4" />
                </Button>
                <Button variant="ghost" size="icon" className="text-zinc-400 hover:text-white hover:bg-primary h-9 w-9 relative">
                  <Bell className="h-4 w-4" />
                  <span className="absolute top-2 right-2 h-1.5 w-1.5 bg-primary rounded-full border border-primary" />
                </Button>
                <div className="h-6 w-px bg-zinc-800 mx-2" />
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <div className="flex items-center gap-3 pl-2 group cursor-pointer">
                        <div className="w-8 h-8 rounded-full bg-primary border-2 border-zinc-900 group-hover:border-primary/50 flex items-center justify-center text-white font-bold text-xs shadow-lg transition-all">
                            {userInitials}
                        </div>
                    </div>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="w-56">
                    <DropdownMenuLabel>{t('my_account')}</DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem asChild>
                      <Link href="/dashboard/account" className="cursor-pointer">
                        <User className="mr-2 h-4 w-4" />
                        <span>{t('account')}</span>
                      </Link>
                    </DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem asChild>
                      <LogoutButton />
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
            </div>
        </header>
        <main className="flex-1 overflow-y-auto bg-background scrollbar-hide">
          <div className="max-w-7xl mx-auto p-8">
            {children}
          </div>
        </main>
      </SidebarInset>
    </SidebarProvider>
  );
}
