---
name: Verdant Harvest
colors:
  surface: '#f7faf4'
  surface-dim: '#d8dbd5'
  surface-bright: '#f7faf4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f5ee'
  surface-container: '#ecefe8'
  surface-container-high: '#e6e9e3'
  surface-container-highest: '#e0e3dd'
  on-surface: '#191d19'
  on-surface-variant: '#414941'
  inverse-surface: '#2d312d'
  inverse-on-surface: '#eff2eb'
  outline: '#717971'
  outline-variant: '#c0c9bf'
  surface-tint: '#326946'
  primary: '#054425'
  on-primary: '#ffffff'
  primary-container: '#245c3a'
  on-primary-container: '#97d2a7'
  inverse-primary: '#99d4a9'
  secondary: '#3d6923'
  on-secondary: '#ffffff'
  secondary-container: '#baee98'
  on-secondary-container: '#416e27'
  tertiary: '#583100'
  on-tertiary: '#ffffff'
  tertiary-container: '#794500'
  on-tertiary-container: '#ffb66c'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#b4f0c4'
  primary-fixed-dim: '#99d4a9'
  on-primary-fixed: '#00210e'
  on-primary-fixed-variant: '#175130'
  secondary-fixed: '#bdf19b'
  secondary-fixed-dim: '#a2d581'
  on-secondary-fixed: '#092100'
  on-secondary-fixed-variant: '#26500c'
  tertiary-fixed: '#ffdcbe'
  tertiary-fixed-dim: '#ffb871'
  on-tertiary-fixed: '#2d1600'
  on-tertiary-fixed-variant: '#6a3c00'
  background: '#f7faf4'
  on-background: '#191d19'
  surface-variant: '#e0e3dd'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.04em
  price-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '800'
    lineHeight: 26px
    letterSpacing: -0.01em
  price-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 15px
    fontWeight: '700'
    lineHeight: 20px
  price-sm-strikethrough:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.5rem
  margin: 1rem
  margin-lg: 1.5rem
  space-2xs: 0.25rem
  space-xs: 0.5rem
  space-sm: 0.75rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.5rem
  space-2xl: 2rem
  space-3xl: 3rem
---

## Brand & Style

This design system expresses the vibrant, life-affirming essence of farm-to-table commerce tailored for modern mobile devices. Rooted in Indonesian agrarian culture, the aesthetic merges organic warmth with refined mobile commerce patterns.

### Design Tone & Personality
- **Natural & Wholesome:** Clean white canvases balanced by warm cream grounding invoke sunlit morning markets, unblemished produce, and sustainable harvesting.
- **Friendly & Approachable:** Generous tap targets, welcoming soft radiuses, and readable sans-serif typography cultivate trust among household shoppers and culinary enthusiasts alike.
- **Modern Efficiency:** Streamlined mobile navigation, quick quantity toggles, and legible badge hierarchies maintain lightning-fast checkout paths.

### Visual Style
The design system adopts a **Modern Tactile & Tonal Layering** approach:
- Surfaces lean on soft structural tints (`#F8F6EF` and `#FFFFFF`) rather than stark black/white starkness.
- Accents deploy sharp, appetizing hues (carrot orange for seasonal deals, leaf green for dietary attributes).
- Structural outlines remain ultra-soft (`#E8ECE6`), creating clear separation without visual clutter.

## Colors

The palette directly references fresh produce, rich foliage, and fertile volcanic soil.

### Palette Architecture
- **Primary (`#245C3A` - Forest Green):** The anchor of the brand. Used for primary CTAs, active bottom navigation highlights, high-tier membership indicators, and brand headers.
- **Secondary (`#78A85A` - Leaf Green):** Fresh supportive accent used for freshness indicators, organic trust badges, discount pill fills, and in-stock badges.
- **Tertiary (`#E99A45` - Carrot Orange):** High-urgency and promotional driver. Applied to flash sale tags, limited-time harvest banners, cart badge counts, and star ratings.
- **Neutral / Text (`#292D29` - Dark Charcoal):** Deep vegetal slate replacing harsh pure black to reduce eye strain while preserving WCAG AAA compliance against white and cream surfaces.
- **Muted Neutral (`#6B726A` - Muted Foliage Grey):** Secondary text, weight annotations, and disabled iconography.
- **Subtle Surface (`#F8F6EF` - Warm Cream):** Canvas wash, background containers, and unselected filter chips.
- **Card / Pure Surface (`#FFFFFF`):** Product cards, bottom sheets, modals, and input fields.
- **Structural Border (`#E8ECE6`):** Card strokes, list item dividers, and search bar perimeters.

## Typography

The typography scale utilizes **Plus Jakarta Sans** across all levels, harnessing its geometric clarity and open counters for dense mobile shopping flows.

### Scale Application
- **Headers & Discovery:** `headline-xl` and `headline-lg` are reserved for on-boarding hero banners, category headers, and basket totals.
- **Product Nomenclature:** Product titles use `headline-sm` or `body-md` in semi-bold to withstand variable-length Indonesian product names (e.g., *Bayam Hijau Hidroponik Organik*).
- **Price Displays:** Distinct `price-*` tokens emphasize currency figures (e.g., `Rp 14.500`) with high-weight geometry, keeping unit specifications (`/ ikat` or `/ 500g`) in `body-sm`.
- **Badging & Micro-data:** `label-sm` utilizes uppercase tracking for harvest labels (`FARM FRESH`, `PROMO HARI INI`).

## Layout & Spacing

The layout is built upon an 8-point spatial model tuned to mobile touch viewports (360dp to 428dp standard Android viewports).

### Viewport Grids & Margins
- **Canvas Margins:** Outer edge margins conform to `1rem` (16dp) on standard handsets, expanding to `1.5rem` (24dp) on foldable and compact tablet layouts.
- **Product Feed Columns:** 2-column asymmetric or balanced grids utilize an internal `0.75rem` (12dp) or `1rem` (16dp) gutter to ensure product imagery remains prominent.
- **Horizontal Carousels:** Category rails, flash sales, and recipe bundles snap along horizontal lists with `0.75rem` (12dp) card spacing and bleed edge margins matching screen padding.

### Component Spacing Rhythm
- **Internal Micro-Gaps (`space-2xs` / 4dp):** Between price lines, weight labels, and rating stars.
- **Stack Gaps (`space-xs` / 8dp):** Between product title, quantity selectors, and sub-attributes.
- **Section Dividers (`space-2xl` / 32dp):** Vertical breaks separating promotional hero banners, flash grids, and seasonal curated lists.

## Elevation & Depth

Visual hierarchy uses **tonal layer separation and ambient, warm-tinted drops** rather than cold synthetic dropshadows.

### Elevation Hierarchy
- **Level 0 (Canvas Base):** `Warm Cream (#F8F6EF)` un-elevated background surface creating warmth beneath elevated elements.
- **Level 1 (Card & Shelf Elements):** `#FFFFFF` surfaces with a 1px border of `#E8ECE6` combined with an ambient shadow:
  - *Shadow formula:* `0px 2px 8px -2px rgba(41, 45, 41, 0.05), 0px 1px 3px 0px rgba(41, 45, 41, 0.03)`
- **Level 2 (Floating Action Bars & Steppers):** Sticky "Add to Cart" summary bars and cart increment buttons:
  - *Shadow formula:* `0px 6px 16px -4px rgba(36, 92, 58, 0.12), 0px 2px 6px -1px rgba(41, 45, 41, 0.06)`
- **Level 3 (Overlays & Bottom Sheets):** Time-slot delivery pickers, item customizers, and category filters:
  - *Shadow formula:* `0px -8px 24px -6px rgba(41, 45, 41, 0.14)`
  - Paired with an overlay scrim of `#292D29` at 40% opacity.

## Shapes

The shape vocabulary emphasizes soft curves mirroring botanical forms while preserving crisp alignment for scan-heavy shopping interfaces.

### Curvature Tokens
- **Standard Corners (`0.5rem` / 8px):** Input fields, quantity adjustment buttons, table headers, and mini promo banners.
- **Large Surfaces (`1rem` / 16px):** Product cards, discovery tiles, voucher cards, and contextual alert containers.
- **Structural Modals (`1.5rem` / 24px):** Top edges of sliding Android bottom sheets, profile action cards, and category highlight hubs.
- **Pills / Full Radius (`9999px`):** Status badges (e.g., "Organik"), filter chips, and primary floating checkout triggers.

## Components

### Buttons
- **Primary CTA:** Background `#245C3A`, text `#FFFFFF`, height `48dp`, radius `0.5rem` (or full pill for sticky cart). Hover/pressed state shifts to `#1B462C`.
- **Secondary / Accent CTA:** Background `#78A85A`, text `#FFFFFF`. Used for "Beli Lagi" (Reorder) or secondary confirmations.
- **Tertiary / Promo Button:** Background `#E99A45`, text `#FFFFFF`. Used strictly in flash deals or checkout urgency paths.
- **Outlined / Ghost Button:** Transparent background, 1.5px border `#245C3A`, text `#245C3A`. Used for voucher claims and recipe ingredients adding.

### Grocery Product Card (Mobile Feed)
- **Container:** Background `#FFFFFF`, border 1px solid `#E8ECE6`, radius `1rem`, internal padding `0.75rem`.
- **Media Box:** 1:1 aspect ratio with background `#F8F6EF` and radius `0.75rem`.
- **Badging:** Floating top-left pill (`label-sm`) with `#78A85A` background and `#FFFFFF` text ("Segar Hari Ini"). Optional discount pill floating top-right in `#E99A45`.
- **Content Flow:** Weight tag (`body-sm`, `#6B726A`) $\rightarrow$ Product Name (`body-md`, `#292D29`, 2-line clamp) $\rightarrow$ Price Block (`price-md`, `#245C3A` + strikethrough original price) $\rightarrow$ Action row.
- **Stepper Action:** Quick `+` button in `#245C3A` with `#FFFFFF` glyph. When quantity $> 0$, transforms into a split counter: `[-] [qty] [+]` pill with `#F8F6EF` container.

### Chips & Filter Pills
- **Unselected:** Surface `#FFFFFF`, border 1px `#E8ECE6`, text `#6B726A`, height `36dp`, radius `9999px`.
- **Selected:** Surface `#245C3A`, border none, text `#FFFFFF`, icon accent `#78A85A`.
- **Promo Chip:** Surface `#FFF5EB`, border 1px `#E99A45`, text `#E99A45`.

### Inputs & Search
- **Search Header (Android App Bar):** Background `#FFFFFF` or `#F8F6EF`, height `44dp`, border 1px solid `#E8ECE6`, text `#292D29`, placeholder `#6B726A`. Left prefix icon is a vegetable or magnifying icon; right suffix includes quick barcode/voice scanner triggers.
- **Field Focus State:** Border transitions to 1.5px `#245C3A` with zero harsh glowing ring.

### Android Navigation Bar & Status Bar
- **System Status Bar:** Transparent scrim over `#F8F6EF` or `#FFFFFF` using dark icons (`#292D29`).
- **Bottom Navigation Bar:** Background `#FFFFFF`, top border 1px solid `#E8ECE6`, height `64dp` plus Android gesture safe inset.
  - Active item: `#245C3A` icon and label with an active soft indicator pill (`#245C3A` at 10% opacity).
  - Inactive item: `#6B726A` icon and label.
  - Cart Item: Includes persistent counter dot in `#E99A45` with white numeric text.

### Delivery Slot Selector & Lists
- **List Items:** Separated by 1px divider `#E8ECE6`. Minimum touch target `48dp`.
- **Delivery Radio Tile:** Surface `#FFFFFF`, selected state wraps with 1.5px border `#245C3A` and subtle background tint of `#245C3A` at 4% opacity. Includes farm dispatch timestamp indicators.