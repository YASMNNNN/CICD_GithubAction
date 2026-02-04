#!/bin/bash
echo "⏳ synchronisation en cours avec le repo local..."
sleep 5
git pull origin main
echo "✅ Sync terminee !"
git status
