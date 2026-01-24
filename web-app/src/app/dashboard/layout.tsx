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
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogFooter } from "@/components/ui/dialog";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Badge } from "@/components/ui/badge";
import { Info, Mail, MessageSquare } from "lucide-react";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const [userInitials, setUserInitials] = useState("JD");
  const [isHelpOpen, setIsHelpOpen] = useState(false);
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
                <Button 
                  variant="ghost" 
                  size="icon" 
                  className="text-zinc-400 hover:text-white hover:bg-primary h-9 w-9"
                  onClick={() => setIsHelpOpen(true)}
                >
                  <HelpCircle className="h-4 w-4" />
                </Button>
                
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button 
                      variant="ghost" 
                      size="icon" 
                      className="text-zinc-400 hover:text-white hover:bg-primary h-9 w-9 relative"
                    >
                      <Bell className="h-4 w-4" />
                      <span className="absolute top-2 right-2 h-1.5 w-1.5 bg-primary rounded-full border border-primary" />
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="w-80 p-0 overflow-hidden">
                    <DropdownMenuLabel className="p-4 border-b border-zinc-800 flex items-center justify-between">
                      {t('notifications')}
                      <Badge variant="outline" className="text-[10px] uppercase tracking-wider">{tCommon('viewAll')}</Badge>
                    </DropdownMenuLabel>
                    <ScrollArea className="h-64">
                      <div className="flex flex-col">
                        <div className="p-4 border-b border-zinc-800/50 hover:bg-zinc-900/50 transition-colors cursor-pointer group">
                          <div className="flex gap-3">
                            <div className="w-8 h-8 rounded-full bg-blue-500/10 flex items-center justify-center shrink-0">
                              <Info className="h-4 w-4 text-blue-500" />
                            </div>
                            <div className="space-y-1">
                              <p className="text-xs font-medium text-zinc-200">System Update</p>
                              <p className="text-[11px] text-zinc-500 leading-normal">Satellite constellation synchronization completed successfully.</p>
                              <p className="text-[10px] text-zinc-600">2 minutes ago</p>
                            </div>
                          </div>
                        </div>
                        <div className="p-4 border-b border-zinc-800/50 hover:bg-zinc-900/50 transition-colors cursor-pointer group">
                          <div className="flex gap-3">
                            <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
                              <Bell className="h-4 w-4 text-primary" />
                            </div>
                            <div className="space-y-1">
                              <p className="text-xs font-medium text-zinc-200">Device Alert</p>
                              <p className="text-[11px] text-zinc-500 leading-normal">TRUCK-042 reported unusual speed variation in Zone B.</p>
                              <p className="text-[10px] text-zinc-600">1 hour ago</p>
                            </div>
                          </div>
                        </div>
                        <div className="p-4 flex items-center justify-center hover:bg-zinc-900/50">
                          <p className="text-[10px] text-zinc-500 font-medium uppercase tracking-widest">{t('noNewNotifications')}</p>
                        </div>
                      </div>
                    </ScrollArea>
                  </DropdownMenuContent>
                </DropdownMenu>
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

        <Dialog open={isHelpOpen} onOpenChange={setIsHelpOpen}>
          <DialogContent className="max-w-2xl bg-zinc-950 border-zinc-800">
            <DialogHeader>
              <DialogTitle className="text-xl font-bold text-zinc-100 flex items-center gap-2">
                <HelpCircle className="h-5 w-5 text-primary" />
                {t('help')}
              </DialogTitle>
              <DialogDescription className="text-zinc-400">
                {tCommon('helpCenterInfo')}
              </DialogDescription>
            </DialogHeader>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 py-4">
              <div className="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900/60 transition-colors cursor-pointer group">
                <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <Info className="h-5 w-5 text-primary" />
                </div>
                <h3 className="text-sm font-semibold text-zinc-200 mb-1">Documentation</h3>
                <p className="text-xs text-zinc-500 leading-relaxed">Detailed guides on how to setup and manage your fleet devices.</p>
              </div>
              <div className="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900/60 transition-colors cursor-pointer group">
                <div className="w-10 h-10 rounded-lg bg-blue-500/10 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <MessageSquare className="h-5 w-5 text-blue-500" />
                </div>
                <h3 className="text-sm font-semibold text-zinc-200 mb-1">Support Chat</h3>
                <p className="text-xs text-zinc-500 leading-relaxed">Connect with our support team for specialized technical assistance.</p>
              </div>
              <div className="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900/60 transition-colors cursor-pointer group">
                <div className="w-10 h-10 rounded-lg bg-amber-500/10 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <Search className="h-5 w-5 text-amber-500" />
                </div>
                <h3 className="text-sm font-semibold text-zinc-200 mb-1">Quick Search</h3>
                <p className="text-xs text-zinc-500 leading-relaxed">Find answers to frequently asked questions in our knowledge base.</p>
              </div>
              <div className="p-4 rounded-xl border border-zinc-800 bg-zinc-900/40 hover:bg-zinc-900/60 transition-colors cursor-pointer group">
                <div className="w-10 h-10 rounded-lg bg-zinc-800 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <Mail className="h-5 w-5 text-zinc-400" />
                </div>
                <h3 className="text-sm font-semibold text-zinc-200 mb-1">Email Support</h3>
                <p className="text-xs text-zinc-500 leading-relaxed">Send us a message and we&apos;ll get back to you within 24 hours.</p>
              </div>
            </div>
            <DialogFooter className="sm:justify-between border-t border-zinc-800 pt-4">
              <p className="text-[10px] text-zinc-600 flex items-center gap-1">
                Version 1.0.4 • Protocol Alpha
              </p>
              <Button size="sm" onClick={() => setIsHelpOpen(false)}>{tCommon('close')}</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </SidebarInset>
    </SidebarProvider>
  );
}
