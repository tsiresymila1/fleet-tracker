"use client"

import * as React from "react"
import { format } from "date-fns"
import { enUS, fr } from 'date-fns/locale'
import { Calendar as CalendarIcon } from "lucide-react"
import { useLocale } from 'next-intl'

import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Calendar } from "@/components/ui/calendar"
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover"

interface DatePickerProps {
  date?: Date
  onDateChange?: (date: Date | undefined) => void
  placeholder?: string
  className?: string
}

export function DatePicker({
  date,
  onDateChange,
  placeholder = "Pick a date",
  className
}: DatePickerProps) {
  const locale = useLocale()
  const dateLocale = locale === 'fr' ? fr : enUS

  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button
          variant={"outline"}
          className={cn(
            "w-full justify-start text-left font-normal pl-9 border-primary/20 hover:border-primary/40 hover:bg-primary/5",
            !date && "text-muted-foreground",
            date && "border-primary/40 text-primary",
            className
          )}
        >
          <CalendarIcon className="mr-2 h-4 w-4" />
          {date ? format(date, "PPP", { locale: dateLocale }) : <span>{placeholder}</span>}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-auto p-0 border-primary/20" align="start">
        <Calendar
          mode="single"
          selected={date}
          onSelect={onDateChange}
          initialFocus
          locale={dateLocale}
        />
      </PopoverContent>
    </Popover>
  )
}
