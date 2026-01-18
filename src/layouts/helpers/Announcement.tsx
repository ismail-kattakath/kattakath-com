import config from "@/config/config.json";
import { markdownify } from "@/lib/utils/textConverter";
import React, { useEffect, useState } from "react";

const { enable, content, expire_days } = config.announcement;

const Cookies = {
  set: (name: string, value: string, options: any = {}) => {
    if (typeof document === "undefined") return;

    const defaults = { path: "/" };
    const opts = { ...defaults, ...options };

    if (typeof opts.expires === "number") {
      opts.expires = new Date(Date.now() + opts.expires * 864e5);
    }
    if (opts.expires instanceof Date) {
      opts.expires = opts.expires.toUTCString();
    }

    let cookieString = `${encodeURIComponent(name)}=${encodeURIComponent(value)}`;

    for (let key in opts) {
      if (!opts[key]) continue;
      cookieString += `; ${key}`;
      if (opts[key] !== true) {
        cookieString += `=${opts[key]}`;
      }
    }

    document.cookie = cookieString;
  },

  get: (name: string): string | null => {
    if (typeof document === "undefined") return null;

    const cookies = document.cookie.split("; ");
    for (let cookie of cookies) {
      const [key, value] = cookie.split("=");
      if (decodeURIComponent(key) === name) {
        return decodeURIComponent(value);
      }
    }
    return null;
  },

  remove: (name: string, options: any = {}) => {
    Cookies.set(name, "", { ...options, expires: -1 });
  },
};

const Announcement: React.FC = () => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    if (enable && content && !Cookies.get("announcement-close")) {
      setIsVisible(true);
    }
  }, []);

  const handleClose = () => {
    Cookies.set("announcement-close", "true", {
      expires: expire_days,
    });
    setIsVisible(false);
  };

  if (!enable || !content || !isVisible) {
    return null;
  }

  return (
    <div className="relative z-999 bg-brand-primary/5 dark:bg-darkmode-brand-primary/10 border-b border-brand-primary/10 dark:border-darkmode-brand-primary/20 px-4 py-2.5 md:py-3 pr-12 text-sm md:text-base text-center transition-all duration-300">
      <p
        className="text-text-dark dark:text-darkmode-text-dark"
        dangerouslySetInnerHTML={{ __html: markdownify(content) }}
      />
      <button
        onClick={handleClose}
        className="absolute top-1/2 right-3 md:right-4 -translate-y-1/2 cursor-pointer flex items-center justify-center w-6 h-6 md:w-7 md:h-7 rounded-full text-text-light dark:text-darkmode-text-light hover:bg-light dark:hover:bg-darkmode-light hover:text-text-dark dark:hover:text-darkmode-text-dark text-lg md:text-xl transition-colors duration-200"
        aria-label="Close announcement"
      >
        &times;
      </button>
    </div>
  );
};

export default Announcement;
