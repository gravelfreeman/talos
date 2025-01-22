#!/bin/bash

# Deplacement dans le repertoire du projet
cd ~/talos || exit 1

# Commande pour chiffrer avec clustertool
./clustertool encrypt

# Mise a jour depuis la branche distante
git pull origin main | tee pull_output.txt

# Verification si la branche est a jour
if ! grep -q "Already up to date" pull_output.txt; then
  	echo
	echo "[!] Branch not up to date! Aborting..."
  exit 1
fi

# Ajout des modifications et commit amendé
git add *
git commit --amend -m "automatic update"

# Push force vers la branche main
git push origin main --force

# Reconciliation et monitoring des kustomizations Flux
flux reconcile source git cluster -n flux-system
flux get kustomizations --watch
