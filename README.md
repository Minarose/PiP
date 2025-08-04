# Participation in Percolation (PiP): A Data-Driven Measure of Network Hubs in Functional Brain Networks

**Brady J. Williamson, PhD<sup>1</sup>**, Minarose Ismail, BSc<sup>2,3</sup>, Darren S Kadis, PhD<sup>2,3**</sup>

<sup>1</sup>University of Cincinnati College of Medicine, Department of Radiology, Cincinnati, OH, 45219  
<sup>2</sup>Neurosciences and Mental Health, Hospital for Sick Children, Toronto, ON, Canada  
<sup>3</sup>Department of Physiology, University of Toronto, Toronto, ON, Canada

## **Overview**  
PiP (Participation in Percolation) is a toolbox for identifying network hubs using a data-driven approach based on probabilistically sampled node attacks and percolation-based collapse analysis.

To validate the method and demonstrate its biological relevance, we apply PiP to magnetoencephalography (MEG) data collected during an expressive language task in a pediatric cohort, localizing functionally relevant language network hubs.

This repository accompanies the study:

> **"Participation in Percolation: 
A Data-Driven Measure of Network Hubs in Functional Brain Networks"**  
> *Williamson et al., 202x*

## Analysis Pipeline

To run the full pipeline on included data:

1. **Run the attack simulation**  
   `scripts/1_PiP_attack.m`  
   → Input: binary adjacency matrices (`data/adjacency_matrices/`)  
   → Output: node participation matrices (`results/`)

2. **Visualize node participation surfaces**  
   `scripts/2_viz_attack_surf.ipynb`  
   → Input: `.mat` files in `results/`  
   → Output: subject-level surface plots

3. **Run consensus clustering**  
   `scripts/3_consensus_clustering.ipynb`  
   → Input: node AUC scores or participation values  
   → Output: critical node maps and comparisons with other hub metrics


 
