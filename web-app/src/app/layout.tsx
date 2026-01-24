import type { Metadata } from "next";
import { Outfit } from "next/font/google";
import "./globals.css";
import { getLocale } from "next-intl/server";
import { NextIntlClientProvider } from "next-intl";
import { getMessages } from "next-intl/server";

const outfit = Outfit({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-outfit",
});

export const metadata: Metadata = {
  title: "FleetTrack - Real-time Fleet Tracking",
  description: "Real-time GPS tracking, device-based identity, and offline-first mobile app for modern fleet management.",
};

import { Toaster } from "sonner";

import { ThemeProvider } from "@/components/theme-provider";
import ProgressBarProvider from "@/components/progress-bar-provider";

export default async function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const locale = await getLocale();
  const messages = await getMessages();

  return (
    <html lang={locale} className={`${outfit.className}`} suppressHydrationWarning>
      <body className="font-outfit antialiased bg-background text-foreground transition-colors duration-300">
        <ThemeProvider
          attribute="class"
          defaultTheme="dark"
          enableSystem
          disableTransitionOnChange
        >
          <NextIntlClientProvider messages={messages} locale={locale}>
            <ProgressBarProvider>
              {children}
            </ProgressBarProvider>
            <Toaster position="top-right" richColors theme="dark" />
          </NextIntlClientProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
