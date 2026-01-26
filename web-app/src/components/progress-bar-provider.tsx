"use client"
import { ProgressProvider } from "@bprogress/next/app";
export default function ProgressProviders({ children }: Readonly<{
  children: React.ReactNode
}>) {
  return <ProgressProvider
    height="4px"
    color="var(--primary)"
    options={{ showSpinner: false }}
    shallowRouting
  >
    {children}
  </ProgressProvider>
}