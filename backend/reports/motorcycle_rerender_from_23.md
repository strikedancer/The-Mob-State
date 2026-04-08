# Motorcycle Rerender Queue From Vehicle 23

De eerste 22 motoren worden voorlopig als "goed genoeg" beschouwd op basis van de laatste batch-run.
Vanaf voertuig 23 moet de motorbatch opnieuw worden gegenereerd zodra er weer budget is.

## Te rerenderen voertuigen

23. moto_bmw_s1000rr_street_2 | BMW S1000RR Street
24. moto_honda_africa_twin_stealth | Honda Africa Twin Stealth
25. moto_ktm_rc_8c_raid | KTM RC 8C Raid
26. moto_kawasaki_versys_raid | Kawasaki Versys Raid
27. event_politie_motor | Politie Motor
28. moto_suzuki_hayabusa_street_2 | Suzuki Hayabusa Street
29. moto_yamaha_r1_track | Yamaha R1 Track
30. moto_ducati_panigale_v4_ghost | Ducati Panigale V4 Ghost
31. moto_ducati_diavel_urban | Ducati Diavel Urban
32. moto_bmw_r1250gs_interceptor | BMW R1250GS Interceptor
33. moto_aprilia_rsv4_interceptor | Aprilia RSV4 Interceptor
34. moto_yamaha_mt_09_urban_2 | Yamaha MT-09 Urban
35. moto_aprilia_tuareg_street | Aprilia Tuareg Street
36. moto_suzuki_hayabusa_street | Suzuki Hayabusa Street
37. moto_harley_davidson_street_glide_stealth | Harley-Davidson Street Glide Stealth
38. moto_bmw_r1250gs_interceptor_2 | BMW R1250GS Interceptor
39. moto_triumph_speed_twin_urban_2 | Triumph Speed Twin Urban
40. moto_suzuki_gsx_r1000_stealth | Suzuki GSX-R1000 Stealth
41. moto_honda_fireblade_interceptor | Honda Fireblade Interceptor
42. moto_kawasaki_h2_urban | Kawasaki H2 Urban
43. moto_aprilia_tuono_v4_carbon_2 | Aprilia Tuono V4 Carbon
44. moto_ktm_1290_super_duke_urban_2 | KTM 1290 Super Duke Urban
45. moto_ducati_panigale_v4_ghost_2 | Ducati Panigale V4 Ghost
46. moto_ktm_890_duke_track | KTM 890 Duke Track
47. moto_triumph_tiger_900_track | Triumph Tiger 900 Track
48. moto_honda_cbr1000rr_carbon_2 | Honda CBR1000RR Carbon
49. moto_triumph_street_triple_raid | Triumph Street Triple Raid
50. moto_suzuki_v_strom_interceptor | Suzuki V-Strom Interceptor
51. moto_harley_davidson_road_king_interceptor | Harley-Davidson Road King Interceptor
52. moto_ducati_monster_raid | Ducati Monster Raid
53. moto_ktm_adventure_ghost | KTM Adventure Ghost
54. moto_honda_cbr1000rr_carbon | Honda CBR1000RR Carbon
55. moto_bmw_m1000r_carbon | BMW M1000R Carbon
56. moto_honda_africa_twin_stealth_2 | Honda Africa Twin Stealth
57. moto_suzuki_gsx_r1000_stealth_2 | Suzuki GSX-R1000 Stealth
58. moto_harley_davidson_low_rider_s_carbon_2 | Harley-Davidson Low Rider S Carbon
59. moto_suzuki_katana_carbon | Suzuki Katana Carbon
60. moto_triumph_speed_twin_urban | Triumph Speed Twin Urban
61. moto_harley_davidson_low_rider_s_carbon | Harley-Davidson Low Rider S Carbon

## Veilig vervolgcommando

Gebruik eerst een kleine proefbatch:

```powershell
python .\backend\scripts\generate_vehicle_images_leonardo.py --estimate-only --category motorcycle --states new,dirty,damaged --start-index 22 --limit 2
python .\backend\scripts\generate_vehicle_images_leonardo.py --category motorcycle --states new,dirty,damaged --start-index 22 --limit 2 --attempts 1 --confirm-batch YES
```

Pas daarna opschalen.
