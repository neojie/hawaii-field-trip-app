# Hawai‘i Field Trip App

An iPhone field app developed for the Princeton Geosciences Hawai‘i Field Trip.

This app is designed to help students document geological observations during field work on Hawai‘i Big Island. The app combines trip logistics, scientific background, field note-taking, photo documentation, GPS tagging, and report generation in one place.

---

# Main Features

## Trip Agenda

The app includes the full field trip itinerary:

- Day 1–Day 8 schedule
- Daily themes and logistics
- Field stop descriptions
- Scientific background for each stop

Example scientific topics include:

- Kīlauea summit activity
- Lower East Rift Zone eruption
- Papakōlea Green Sand Beach
- Kīlauea Iki lava lake
- Mauna Ulu lava flows
- Fumaroles and volcanic gases
- Mauna Kea glaciation
- Hualālai mantle xenoliths
- Basalt weathering
- Coral reefs and ocean carbon cycling

---

## Field Notebook

At each stop, students can:

- Write field notes
- Take photos using the iPhone camera
- Select photos from the photo library
- Save observations with GPS coordinates
- Organize observations by stop

---

## Field Report Export

At the end of the trip, students can export a PDF report containing:

- Student name
- Project title
- Field observations
- Photos with captions
- GPS coordinates
- Time stamps

---

# Installation Guide (iPhone)

## Requirements

Before installation, make sure you have:

- A Mac computer
- Xcode installed
- An Apple ID
- An iPhone
- A USB cable (or wireless debugging enabled)

---

## Step 1 — Download the Project

Clone this repository:

```bash
git clone https://github.com/YOUR_USERNAME/hawaii-field-trip-app.git
```

Or download the ZIP file directly from GitHub.

---

## Step 2 — Open in Xcode

Open:

```text
field_v2.xcodeproj
```

---

## Step 3 — Connect Your iPhone

Connect your iPhone to your Mac.

In Xcode:

- Look at the top toolbar
- Select your iPhone as the target device

---

## Step 4 — Signing

In Xcode:

1. Click the project icon in the left sidebar
2. Select:

```text
field_v2
```

3. Open:

```text
Signing & Capabilities
```

4. Under:

```text
Team
```

Select your Apple ID / Personal Team.

If you do not see your Apple ID:

Go to:

```text
Xcode → Settings → Accounts
```

Then sign in with your Apple ID.

---

## Step 5 — Build and Install

Click:

```text
▶ Run
```

Xcode will build the app and install it onto your iPhone.

---

## Step 6 — Trust Developer Profile

The first time you open the app, iPhone may block it.

On your iPhone, go to:

```text
Settings → General → VPN & Device Management
```

Find your Apple ID developer profile.

Tap:

```text
Trust
```

Then open the app again.

---

# First-Time Setup

When opening the app for the first time:

Please allow:

- Camera access
- Photo Library access
- Location access

These permissions are required for field documentation.

Then:

1. Enter your name
2. Enter your project title
3. Test one note
4. Test one photo
5. Test GPS
6. Test PDF export

---

# How to Use During the Field Trip

## At Each Stop

1. Open the correct day
2. Open the correct stop
3. Read the scientific background
4. Answer the field questions
5. Add your observations
6. Take photos
7. Save your notes

---

## GPS Recording

Before saving important observations:

Tap:

```text
Refresh Location
```

This saves your observation coordinates.

---

## Export Final Report

At the end of the trip:

1. Return to the main page
2. Tap:

```text
Preview / Export Field Report
```

3. Tap:

```text
Export PDF
```

4. Save to Files, AirDrop, or email it to yourself

---

# Troubleshooting

## Camera not working

Make sure Camera permission is enabled:

```text
iPhone Settings → Privacy & Security → Camera
```

---

## GPS not working

Make sure Location Services are enabled:

```text
iPhone Settings → Privacy & Security → Location Services
```

---

## PDF export blank

Usually this means:

- No notes or photos have been added yet
- Or the app needs to be restarted

Try:

1. Add one note
2. Add one photo
3. Export again

---

# Scientific Goals

This app supports field projects in:

- Volcanology
- Seismology
- Geodynamics
- Mineral Physics
- Hotspot Magmatism
- Mantle Plumes
- Ocean Carbon Cycling
- Climate and Weathering

---

# Developed For

Princeton University  
Department of Geosciences  
Hawai‘i Big Island Field Trip

Faculty Lead: Jie Deng

---

# Future Development

Planned upgrades:

- Interactive maps
- Shared team observations
- Instructor annotations
- Cloud sync
- Android version

