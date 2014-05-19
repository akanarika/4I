//Ramdow normal map 
uniform sampler2D rnm;
//Texture storing normal and depth of the scene
uniform sampler2D normalMap;
uniform sampler2D color;

varying vec2 uv;
uniform float totStrength = 1.5;
uniform float strength = 0.07;
uniform float offset = 18.0;
uniform float falloff = 0.000002;
uniform float rad = 0.006;
#define SAMPLES 128 // 10 is good

const float invSamples = 1.0/128.0;
void main(void)
{
vec3 pSphere[1000] = vec3[](vec3(-0.5921,-0.6400,0.4897),vec3(-0.3803,0.4898,0.7845),vec3(0.8572,-0.0161,-0.5148),vec3(0.1085,0.6629,-0.7408),vec3(-0.4805,-0.6832,-0.5499),vec3(-0.7538,-0.5846,-0.3000),vec3(-0.6871,0.5887,-0.4258),vec3(0.3251,0.4041,0.8550),vec3(0.4358,0.0694,-0.8974),vec3(-0.8644,0.4674,0.1853),
vec3(0.2971,0.6761,-0.6742),vec3(-0.1116,-0.7276,0.6768),vec3(-0.5126,0.5433,-0.6649),vec3(0.5441,-0.8390,0.0044),vec3(-0.0051,-0.0515,0.9987),vec3(-0.8635,-0.4132,-0.2892),vec3(0.1879,0.3797,-0.9058),vec3(0.7906,-0.2169,-0.5727),vec3(-0.0941,0.9744,-0.2043),vec3(0.8391,-0.4303,-0.3327),
vec3(0.1380,0.8298,-0.5408),vec3(-0.3427,0.3489,0.8722),vec3(0.7934,0.4862,0.3664),vec3(-0.2432,-0.2944,0.9242),vec3(0.4190,0.8995,-0.1241),vec3(0.4549,0.1323,0.8807),vec3(-0.0256,-0.1502,-0.9883),vec3(-0.5605,0.7982,0.2206),vec3(-0.4252,-0.6757,0.6022),vec3(-0.6302,0.5636,-0.5340),
vec3(-0.3496,-0.3601,0.8649),vec3(0.8423,0.1153,0.5265),vec3(0.6410,-0.4036,0.6529),vec3(0.3090,-0.9397,0.1469),vec3(-0.0212,-0.8106,0.5852),vec3(0.3630,-0.8668,-0.3419),vec3(-0.6190,0.5576,-0.5531),vec3(-0.6865,-0.6229,-0.3752),vec3(-0.8768,-0.4502,0.1690),vec3(-0.7381,-0.1410,0.6598),
vec3(-0.1424,0.8967,-0.4191),vec3(0.0084,0.9808,-0.1949),vec3(-0.6581,0.2064,0.7241),vec3(0.1359,0.9638,0.2295),vec3(0.0627,-0.1761,0.9824),vec3(0.8024,-0.0702,-0.5926),vec3(0.7427,0.1416,0.6544),vec3(-0.9127,-0.2080,0.3517),vec3(0.7386,0.4499,-0.5021),vec3(0.3211,-0.9458,-0.0484),
vec3(0.9771,-0.0667,-0.2018),vec3(0.8946,0.4002,0.1989),vec3(0.7420,-0.2970,0.6010),vec3(0.6093,0.0699,-0.7899),vec3(-0.3093,-0.7007,0.6429),vec3(0.1538,-0.7148,0.6822),vec3(-0.9348,-0.2036,-0.2910),vec3(0.7442,-0.6531,-0.1399),vec3(0.7969,-0.5866,0.1445),vec3(-0.6437,-0.6514,0.4016),
vec3(0.5664,0.6663,0.4849),vec3(0.1721,0.8393,0.5158),vec3(0.4033,0.8878,-0.2217),vec3(0.9560,0.2571,-0.1414),vec3(0.3198,0.2544,0.9127),vec3(-0.7361,-0.6609,0.1459),vec3(0.6639,-0.2645,0.6994),vec3(-0.5458,0.7086,-0.4473),vec3(-0.8207,0.5163,0.2446),vec3(0.9795,-0.0966,0.1767),
vec3(0.3535,-0.1258,0.9269),vec3(-0.2493,-0.5020,-0.8282),vec3(0.9973,-0.0734,0.0010),vec3(0.1055,-0.9935,0.0432),vec3(-0.2968,0.4899,-0.8197),vec3(-0.3073,-0.5006,0.8093),vec3(0.0234,0.6391,0.7688),vec3(-0.2799,0.9522,-0.1220),vec3(-0.3509,-0.7479,0.5634),vec3(-0.7003,-0.1238,-0.7031),
vec3(-0.8249,0.5120,0.2396),vec3(-0.7016,-0.5277,-0.4788),vec3(0.0032,-0.9941,-0.1087),vec3(-0.6280,-0.3636,0.6880),vec3(-0.7526,-0.2539,-0.6076),vec3(-0.7959,-0.4611,-0.3923),vec3(-0.9967,-0.0742,-0.0334),vec3(0.8214,0.4691,-0.3244),vec3(-0.1525,-0.7876,0.5970),vec3(0.2222,-0.0054,0.9750),
vec3(-0.4466,0.5793,-0.6819),vec3(0.8365,-0.1527,-0.5262),vec3(-0.5209,0.7517,0.4045),vec3(0.7327,-0.6334,-0.2491),vec3(-0.3071,0.0899,0.9474),vec3(-0.2808,0.1698,0.9446),vec3(0.1929,0.9382,0.2874),vec3(0.4885,0.4926,0.7202),vec3(-0.3547,0.9141,-0.1962),vec3(-0.1443,-0.9537,0.2639),
vec3(0.0495,-0.2361,0.9705),vec3(-0.3434,-0.9316,0.1190),vec3(0.4970,0.0307,0.8672),vec3(0.4962,-0.7481,0.4407),vec3(0.8828,-0.4686,-0.0319),vec3(0.1261,-0.9522,0.2781),vec3(0.6091,0.1673,0.7753),vec3(-0.5755,0.5529,-0.6025),vec3(-0.2767,-0.9379,-0.2093),vec3(-0.0226,-0.1748,0.9844),
vec3(0.1578,0.9680,-0.1953),vec3(-0.1133,0.9414,0.3177),vec3(-0.2773,-0.5280,0.8027),vec3(-0.1342,0.0191,0.9908),vec3(-0.6785,-0.6677,0.3063),vec3(0.0529,0.6196,-0.7831),vec3(0.1650,0.3347,-0.9278),vec3(0.4662,-0.8526,0.2362),vec3(0.1052,-0.9853,0.1343),vec3(0.3506,-0.1531,0.9239),
vec3(0.6780,0.5459,0.4922),vec3(0.3906,0.8612,0.3250),vec3(0.8115,0.5825,0.0466),vec3(-0.8753,0.0564,-0.4802),vec3(0.1335,0.3584,0.9240),vec3(0.7910,-0.6065,0.0804),vec3(0.2784,0.1998,-0.9395),vec3(0.8845,0.2520,0.3926),vec3(-0.9352,-0.3520,0.0394),vec3(0.0664,-0.4667,-0.8819),
vec3(-0.2374,0.5789,0.7801),vec3(0.4059,0.8485,-0.3396),vec3(-0.4461,0.7133,-0.5406),vec3(0.1575,0.6157,-0.7721),vec3(-0.9239,-0.0590,-0.3782),vec3(0.6985,-0.4660,-0.5431),vec3(-0.6568,-0.6900,0.3040),vec3(0.3993,0.2961,-0.8677),vec3(-0.6915,0.5658,-0.4491),vec3(0.8473,0.3027,-0.4364),
vec3(-0.6497,-0.0052,0.7601),vec3(-0.9037,0.4134,-0.1113),vec3(0.8590,-0.0132,0.5118),vec3(0.3693,-0.9060,0.2066),vec3(-0.8207,0.0742,0.5665),vec3(0.5008,-0.3912,-0.7721),vec3(0.1881,0.2203,0.9571),vec3(-0.5524,0.4569,0.6972),vec3(0.3937,-0.1933,-0.8987),vec3(0.8666,-0.4944,-0.0676),
vec3(-0.2126,-0.9128,-0.3487),vec3(-0.7107,-0.6535,0.2604),vec3(-0.4658,0.7015,-0.5394),vec3(0.9085,-0.3862,0.1598),vec3(0.6929,0.6909,0.2063),vec3(-0.1192,-0.9726,0.1998),vec3(-0.6023,-0.7916,-0.1031),vec3(0.1845,-0.3204,-0.9292),vec3(-0.8023,0.5963,0.0276),vec3(-0.0011,-0.9828,-0.1845),
vec3(0.3168,-0.5340,-0.7839),vec3(-0.4383,0.8952,-0.0802),vec3(-0.9420,-0.3209,-0.0982),vec3(0.9862,-0.1301,0.1023),vec3(-0.7541,-0.2414,0.6108),vec3(-0.4433,0.8013,0.4017),vec3(-0.4882,-0.4554,0.7445),vec3(-0.2849,0.3416,-0.8956),vec3(0.0339,-0.8274,-0.5606),vec3(-0.8544,0.5133,-0.0807),
vec3(-0.3983,0.0192,0.9171),vec3(-0.2772,-0.7660,0.5801),vec3(0.9808,-0.1697,-0.0963),vec3(-0.4425,0.8326,-0.3331),vec3(0.2472,-0.4016,-0.8818),vec3(-0.0601,-0.8742,0.4818),vec3(0.9587,-0.2839,0.0136),vec3(0.7839,0.1594,-0.6001),vec3(-0.6155,0.7746,-0.1456),vec3(-0.3907,-0.6390,-0.6626),
vec3(-0.1699,0.8472,0.5034),vec3(0.1186,0.9574,-0.2633),vec3(-0.1132,-0.4543,0.8836),vec3(-0.1842,-0.1832,-0.9657),vec3(-0.6342,-0.4059,0.6581),vec3(-0.5161,-0.8182,0.2532),vec3(0.9528,0.2935,0.0775),vec3(-0.5546,0.7758,0.3010),vec3(-0.8500,0.2683,0.4533),vec3(0.0334,0.5841,-0.8110),
vec3(-0.1428,-0.6398,0.7551),vec3(0.1472,-0.1869,-0.9713),vec3(-0.1793,0.8937,-0.4114),vec3(-0.0913,-0.7628,-0.6402),vec3(0.3387,0.3979,0.8526),vec3(0.2613,-0.4311,-0.8636),vec3(0.6356,0.7548,0.1622),vec3(-0.8177,-0.5061,0.2743),vec3(-0.6355,0.7104,0.3025),vec3(0.2389,-0.6412,0.7292),
vec3(-0.4595,-0.0109,-0.8881),vec3(-0.7719,0.0505,0.6337),vec3(0.7150,-0.6968,0.0578),vec3(-0.5562,0.7346,0.3887),vec3(-0.7771,0.2555,-0.5752),vec3(0.9702,-0.2263,0.0866),vec3(0.8822,0.2401,0.4050),vec3(0.4024,-0.0690,0.9129),vec3(0.3705,0.9222,-0.1109),vec3(-0.2781,-0.4849,-0.8292),
vec3(-0.3981,-0.2403,-0.8853),vec3(-0.4379,-0.8609,0.2589),vec3(-0.5175,0.6175,0.5924),vec3(-0.6725,-0.6337,0.3824),vec3(0.3564,-0.8816,-0.3094),vec3(0.4455,0.0542,0.8936),vec3(0.8636,0.5025,0.0404),vec3(0.4145,-0.0662,0.9076),vec3(-0.3034,-0.4251,-0.8528),vec3(0.0953,0.8047,-0.5859),
vec3(-0.6862,0.4759,0.5501),vec3(0.4034,0.3886,0.8284),vec3(-0.0954,0.8195,0.5651),vec3(-0.0450,0.9115,-0.4089),vec3(-0.3523,0.6253,-0.6963),vec3(0.4140,0.5869,0.6958),vec3(-0.4747,0.6709,0.5697),vec3(0.6415,0.6151,-0.4583),vec3(0.6263,-0.5581,-0.5444),vec3(0.7746,0.5213,-0.3580),
vec3(0.6805,-0.3200,0.6591),vec3(-0.6159,0.4533,0.6444),vec3(0.9464,0.2905,0.1414),vec3(-0.5427,0.8276,0.1437),vec3(-0.0796,-0.9003,-0.4280),vec3(0.2542,-0.8814,0.3983),vec3(-0.7737,-0.2243,0.5925),vec3(-0.3874,-0.9145,-0.1168),vec3(0.7803,-0.6161,-0.1076),vec3(0.9391,0.3367,-0.0687),
vec3(-0.2968,0.8465,-0.4419),vec3(0.8973,0.2680,0.3508),vec3(0.1982,0.5558,0.8073),vec3(-0.1074,-0.5665,0.8171),vec3(-0.1535,-0.8556,0.4944),vec3(0.6315,-0.6097,-0.4790),vec3(-0.8039,-0.4581,0.3793),vec3(0.6110,0.2907,-0.7363),vec3(0.5820,-0.3070,-0.7530),vec3(0.2446,-0.7470,-0.6182),
vec3(-0.1580,0.6878,-0.7085),vec3(-0.9486,-0.2670,0.1701),vec3(0.5191,-0.0498,-0.8533),vec3(-0.1636,-0.7468,0.6447),vec3(0.4747,-0.7589,0.4458),vec3(-0.4786,0.2134,0.8517),vec3(-0.9829,0.1835,-0.0147),vec3(-0.8825,-0.3540,0.3098),vec3(-0.0748,0.6210,0.7802),vec3(-0.0061,-0.9970,0.0771),
vec3(-0.8999,-0.0220,-0.4356),vec3(-0.1850,-0.2442,0.9519),vec3(-0.1330,0.3503,-0.9271),vec3(0.6035,0.7177,-0.3475),vec3(-0.3203,0.0495,0.9460),vec3(-0.6252,0.7323,-0.2699),vec3(0.2192,-0.8979,-0.3817),vec3(0.1234,-0.6403,-0.7582),vec3(-0.2721,-0.4842,0.8315),vec3(0.4575,0.5091,-0.7290),
vec3(0.9333,0.1272,-0.3358),vec3(-0.5643,-0.2228,0.7950),vec3(-0.3139,0.9495,-0.0007),vec3(0.9034,-0.3616,0.2306),vec3(0.9790,-0.1180,0.1663),vec3(-0.2094,0.8938,0.3965),vec3(0.1059,-0.3204,-0.9413),vec3(0.7932,-0.6064,0.0558),vec3(-0.2883,-0.2027,-0.9359),vec3(0.5642,-0.5036,0.6543),
vec3(0.8888,-0.3280,-0.3200),vec3(-0.6864,-0.2190,0.6934),vec3(-0.1166,-0.8535,-0.5079),vec3(-0.8741,-0.4576,0.1630),vec3(0.4771,0.0782,0.8754),vec3(-0.4028,0.1406,-0.9044),vec3(-0.2741,-0.3594,-0.8920),vec3(-0.2817,-0.0378,-0.9588),vec3(-0.6477,0.6699,0.3630),vec3(0.9049,-0.3772,0.1973),
vec3(0.3046,-0.5580,-0.7719),vec3(0.4698,-0.6544,0.5925),vec3(-0.6765,0.6977,0.2357),vec3(-0.4259,-0.2824,-0.8596),vec3(0.3535,-0.3646,-0.8614),vec3(0.6266,-0.2782,-0.7280),vec3(-0.4001,-0.7114,0.5778),vec3(0.1554,0.5579,-0.8152),vec3(-0.4837,-0.7008,-0.5243),vec3(0.7721,0.3755,-0.5127),
vec3(-0.5104,0.3388,-0.7904),vec3(-0.3477,-0.6045,0.7167),vec3(0.8396,-0.3713,0.3964),vec3(0.3303,-0.8200,0.4675),vec3(-0.9491,0.0924,0.3011),vec3(0.0424,-0.9986,0.0325),vec3(-0.8133,0.4669,-0.3472),vec3(0.9314,-0.1669,0.3236),vec3(0.6423,-0.0486,-0.7649),vec3(0.4666,-0.5350,-0.7044),
vec3(-0.2132,0.1789,-0.9605),vec3(-0.3562,0.1041,0.9286),vec3(0.0071,0.3390,0.9407),vec3(0.1414,-0.6435,-0.7523),vec3(0.7395,-0.6700,-0.0652),vec3(0.8134,-0.4900,0.3134),vec3(-0.8475,-0.3250,-0.4196),vec3(-0.6999,-0.5010,0.5091),vec3(0.5895,0.7994,0.1162),vec3(0.7995,-0.5831,-0.1444),
vec3(-0.8423,0.2714,-0.4656),vec3(0.2369,0.8285,0.5075),vec3(0.4881,-0.3563,0.7968),vec3(0.0703,-0.8867,0.4569),vec3(0.7266,-0.6613,-0.1863),vec3(-0.1048,0.4696,0.8766),vec3(-0.4046,-0.7727,-0.4891),vec3(-0.5118,-0.8565,0.0663),vec3(0.2979,0.2899,0.9095),vec3(-0.7396,0.4870,-0.4645),
vec3(-0.1370,0.8552,-0.4998),vec3(-0.1077,-0.5067,0.8553),vec3(-0.1053,0.4944,-0.8628),vec3(0.7280,-0.5559,-0.4012),vec3(0.4550,-0.8715,0.1832),vec3(-0.6203,0.5130,-0.5934),vec3(-0.9623,0.0127,0.2718),vec3(-0.2727,-0.7547,0.5967),vec3(0.5056,-0.8627,0.0034),vec3(-0.7360,-0.6060,0.3016),
vec3(-0.7188,-0.3647,0.5919),vec3(-0.3890,0.7512,-0.5333),vec3(-0.9430,0.2648,0.2017),vec3(-0.1425,-0.6156,-0.7751),vec3(0.7473,-0.6638,0.0315),vec3(-0.1342,-0.7249,0.6757),vec3(0.5364,0.0630,0.8416),vec3(-0.4552,-0.8904,-0.0035),vec3(-0.8296,0.3375,-0.4448),vec3(-0.8806,0.3627,0.3050),
vec3(0.4085,0.3695,0.8346),vec3(0.3952,-0.9184,0.0197),vec3(-0.1437,0.2827,0.9484),vec3(0.0189,0.7957,-0.6054),vec3(-0.3459,0.5250,-0.7776),vec3(-0.6492,0.6436,-0.4053),vec3(-0.9368,-0.2821,-0.2072),vec3(-0.9136,-0.3745,-0.1585),vec3(-0.7348,0.5639,-0.3770),vec3(-0.7393,0.5505,0.3877),
vec3(-0.5750,-0.0557,-0.8163),vec3(-0.5382,-0.8197,-0.1958),vec3(0.8692,-0.2769,-0.4096),vec3(-0.1594,-0.9082,-0.3870),vec3(-0.4974,0.3610,-0.7889),vec3(0.4833,-0.8551,0.1877),vec3(0.5984,0.6731,-0.4345),vec3(0.6726,0.2686,-0.6896),vec3(0.0443,0.0259,-0.9987),vec3(0.4643,0.7728,-0.4328),
vec3(-0.4473,0.8886,0.1016),vec3(-0.2141,0.6355,0.7418),vec3(0.4013,0.0295,-0.9155),vec3(-0.5688,-0.1457,0.8094),vec3(0.5572,0.3806,-0.7381),vec3(0.4508,0.5927,0.6675),vec3(-0.5430,-0.5866,0.6009),vec3(0.3482,-0.4246,0.8358),vec3(0.6793,-0.1110,-0.7254),vec3(-0.9025,-0.4305,0.0095),
vec3(0.9816,-0.0194,-0.1901),vec3(-0.7150,-0.2500,-0.6529),vec3(-0.9840,-0.0959,0.1504),vec3(-0.4744,0.8543,0.2124),vec3(-0.7428,0.3495,-0.5711),vec3(-0.9979,0.0514,0.0399),vec3(0.1866,0.0893,0.9784),vec3(0.7612,-0.6482,-0.0202),vec3(0.8460,0.3638,0.3897),vec3(-0.9061,0.3841,-0.1772),
vec3(0.1697,-0.3248,-0.9304),vec3(-0.7175,0.5599,-0.4143),vec3(-0.6035,-0.5219,0.6029),vec3(0.3978,-0.8646,-0.3070),vec3(0.4174,-0.3623,-0.8334),vec3(0.9076,-0.4193,0.0222),vec3(0.3504,0.8979,-0.2663),vec3(-0.0473,0.8766,0.4790),vec3(0.8001,-0.5978,0.0495),vec3(-0.6605,-0.4390,0.6090),
vec3(-0.7733,-0.0187,0.6338),vec3(-0.5950,-0.5102,-0.6211),vec3(0.2782,-0.5968,-0.7526),vec3(-0.7514,-0.1526,0.6420),vec3(0.2851,0.9180,0.2758),vec3(-0.2414,0.0720,-0.9678),vec3(-0.5491,0.2672,0.7919),vec3(0.9769,-0.2116,0.0308),vec3(-0.7258,-0.6821,0.0890),vec3(-0.3287,-0.9201,0.2129),
vec3(-0.1591,-0.8387,0.5209),vec3(-0.4023,0.5771,0.7107),vec3(-0.9666,-0.1036,-0.2343),vec3(-0.5218,-0.1941,-0.8307),vec3(0.4899,0.7357,0.4677),vec3(-0.8712,-0.3580,-0.3360),vec3(-0.2494,-0.6900,0.6795),vec3(-0.8652,0.4309,-0.2566),vec3(0.3892,-0.6462,0.6564),vec3(-0.0890,-0.7573,-0.6470),
vec3(-0.4282,0.5174,-0.7410),vec3(-0.6235,0.1845,0.7598),vec3(-0.3103,0.2688,-0.9118),vec3(0.1483,-0.9157,0.3734),vec3(-0.0872,-0.8797,0.4675),vec3(-0.8984,0.4208,-0.1257),vec3(-0.3360,-0.9107,-0.2403),vec3(0.2658,-0.0953,0.9593),vec3(0.2090,-0.9568,-0.2020),vec3(-0.2736,-0.9544,-0.1196),
vec3(0.5623,0.4612,-0.6864),vec3(-0.7221,0.5979,-0.3479),vec3(-0.7809,-0.5018,-0.3719),vec3(-0.5945,0.1551,0.7890),vec3(0.8198,0.2683,-0.5060),vec3(0.1236,0.9173,-0.3786),vec3(0.4962,-0.8489,-0.1823),vec3(0.9050,0.0892,0.4160),vec3(0.4596,-0.5299,-0.7127),vec3(0.5907,0.3155,0.7426),
vec3(-0.2689,-0.4823,-0.8337),vec3(-0.9971,-0.0013,-0.0765),vec3(0.0686,0.3364,-0.9392),vec3(-0.7765,-0.3751,0.5064),vec3(0.6594,0.6365,0.4001),vec3(-0.3902,-0.7223,-0.5710),vec3(-0.7563,-0.5465,0.3598),vec3(0.9326,0.3422,0.1146),vec3(0.6686,0.2471,0.7014),vec3(0.5710,0.8125,0.1171),
vec3(0.5907,0.0732,0.8035),vec3(-0.9062,0.3910,-0.1610),vec3(0.4736,-0.8338,-0.2837),vec3(-0.7399,-0.6723,-0.0220),vec3(-0.8658,-0.1101,-0.4881),vec3(0.3366,-0.3873,0.8583),vec3(0.8156,0.5747,-0.0665),vec3(0.7293,-0.4755,-0.4920),vec3(0.7710,0.6218,-0.1376),vec3(-0.9091,-0.0975,0.4051),
vec3(0.6100,0.7679,-0.1953),vec3(-0.7184,-0.2811,-0.6363),vec3(0.7014,0.0202,0.7125),vec3(0.1031,-0.9803,0.1684),vec3(0.5623,-0.7873,-0.2528),vec3(0.7199,-0.4147,-0.5566),vec3(0.8244,-0.0677,-0.5620),vec3(-0.9985,-0.0322,0.0445),vec3(-0.1330,0.9821,-0.1332),vec3(0.7061,0.5181,0.4826),
vec3(-0.5112,-0.0252,-0.8591),vec3(-0.6178,-0.3685,0.6947),vec3(0.0755,-0.9300,0.3598),vec3(0.5957,0.3421,-0.7267),vec3(-0.3677,-0.5924,0.7168),vec3(-0.7952,-0.0852,-0.6003),vec3(0.4649,0.8590,0.2147),vec3(0.9230,-0.3751,0.0861),vec3(-0.6215,-0.3971,-0.6754),vec3(-0.1396,0.0546,-0.9887),
vec3(0.7845,-0.2997,0.5430),vec3(-0.4728,-0.7043,0.5296),vec3(-0.9428,0.2936,-0.1579),vec3(0.2473,-0.3914,-0.8864),vec3(-0.9646,-0.2005,0.1715),vec3(-0.7154,-0.2519,-0.6517),vec3(-0.3783,-0.8049,0.4572),vec3(-0.6700,0.7392,0.0686),vec3(0.0585,0.8676,-0.4939),vec3(-0.4852,-0.2625,0.8341),
vec3(0.5739,-0.6356,0.5164),vec3(-0.5276,0.3500,0.7741),vec3(0.3847,0.3290,-0.8624),vec3(-0.7265,0.2675,-0.6329),vec3(-0.2730,0.8370,0.4741),vec3(-0.7485,0.5339,0.3934),vec3(0.4164,-0.7209,0.5540),vec3(-0.8222,0.5692,0.0038),vec3(-0.7626,0.6295,-0.1490),vec3(-0.6236,0.7494,0.2225),
vec3(0.4470,0.5421,0.7115),vec3(-0.0598,0.9379,0.3416),vec3(0.8539,0.5182,0.0472),vec3(-0.8269,0.3929,-0.4024),vec3(-0.0418,0.9121,0.4079),vec3(-0.2860,0.9285,-0.2368),vec3(-0.8824,0.4506,0.1354),vec3(0.4622,0.4297,0.7757),vec3(-0.7273,0.0226,0.6859),vec3(-0.1632,-0.5807,0.7976),
vec3(0.0193,0.4783,0.8780),vec3(0.1696,-0.7571,0.6309),vec3(0.0658,0.0331,-0.9973),vec3(-0.0872,0.0687,-0.9938),vec3(0.5649,0.0120,-0.8251),vec3(0.1609,0.8632,-0.4785),vec3(0.2985,0.0024,-0.9544),vec3(0.3686,0.9171,-0.1518),vec3(0.5929,0.7399,-0.3179),vec3(-0.1129,0.9902,0.0827),
vec3(0.2377,0.4658,0.8523),vec3(0.5893,0.7002,-0.4030),vec3(-0.7693,-0.5507,-0.3238),vec3(0.5650,-0.4048,0.7190),vec3(0.8798,-0.3523,-0.3190),vec3(0.1243,0.6788,-0.7238),vec3(-0.9940,0.1087,0.0156),vec3(-0.4987,0.4924,0.7133),vec3(-0.9620,-0.1448,-0.2314),vec3(-0.0859,0.9162,0.3914),
vec3(0.8789,0.4026,0.2558),vec3(-0.9165,0.3876,-0.0992),vec3(0.4598,0.8865,-0.0528),vec3(0.4312,0.0714,0.8994),vec3(0.5310,-0.1554,-0.8330),vec3(-0.8138,0.3792,-0.4403),vec3(0.9655,-0.2378,-0.1060),vec3(0.0767,-0.9815,0.1751),vec3(0.6547,0.0303,0.7553),vec3(-0.4247,-0.9032,-0.0618),
vec3(-0.2711,-0.9544,-0.1252),vec3(-0.5329,-0.6882,0.4924),vec3(-0.9445,-0.3221,-0.0642),vec3(0.1378,0.6784,0.7217),vec3(0.1398,-0.9879,-0.0670),vec3(0.1376,0.9905,-0.0038),vec3(-0.6883,0.7250,-0.0251),vec3(0.6511,-0.5323,-0.5411),vec3(0.3467,-0.4390,-0.8289),vec3(-0.4101,0.2885,-0.8652),
vec3(-0.2610,0.5731,0.7768),vec3(-0.6562,-0.5335,-0.5337),vec3(0.5836,-0.3694,0.7232),vec3(0.7621,-0.4897,0.4235),vec3(-0.5590,-0.3627,0.7456),vec3(-0.2391,0.4188,0.8760),vec3(0.4182,-0.5530,-0.7206),vec3(-0.9139,0.3460,-0.2122),vec3(0.2277,-0.1561,0.9611),vec3(0.9364,0.1981,0.2896),
vec3(-0.5969,-0.1233,0.7928),vec3(-0.2088,-0.9773,-0.0355),vec3(0.1013,0.2129,-0.9718),vec3(-0.5014,0.8296,0.2458),vec3(0.3216,0.7793,-0.5378),vec3(-0.4360,0.8983,0.0549),vec3(-0.7350,0.5073,0.4500),vec3(-0.9315,-0.2934,0.2148),vec3(0.9385,0.2967,0.1767),vec3(-0.9372,-0.3224,-0.1331),
vec3(-0.1334,0.8488,-0.5117),vec3(0.0528,0.9884,-0.1421),vec3(0.0086,0.2006,-0.9796),vec3(0.5529,0.8043,0.2176),vec3(0.3863,-0.1085,0.9160),vec3(0.5403,-0.2311,-0.8091),vec3(0.1551,-0.3365,-0.9288),vec3(-0.0865,-0.6291,0.7725),vec3(0.3876,0.7704,-0.5061),vec3(-0.1202,0.1446,-0.9822),
vec3(0.2914,0.7200,0.6298),vec3(0.6950,0.0052,-0.7190),vec3(-0.2636,0.5944,0.7597),vec3(-0.1829,-0.5583,-0.8092),vec3(-0.6746,-0.6767,-0.2949),vec3(-0.9467,-0.2626,0.1868),vec3(-0.9140,0.3683,0.1704),vec3(-0.2195,0.9162,0.3354),vec3(-0.9551,-0.0100,0.2961),vec3(0.0718,-0.9885,-0.1333),
vec3(0.0540,-0.6914,-0.7205),vec3(-0.7670,-0.3972,0.5039),vec3(-0.0126,-0.8562,-0.5164),vec3(-0.5820,-0.7555,0.3009),vec3(0.5000,0.4890,0.7147),vec3(-0.5557,-0.0154,-0.8313),vec3(-0.1890,0.2698,0.9442),vec3(0.2922,0.1910,-0.9371),vec3(0.4440,0.5940,0.6708),vec3(0.2371,0.7021,0.6714),
vec3(-0.2042,-0.3844,-0.9003),vec3(-0.9050,0.4154,0.0918),vec3(-0.1585,-0.4351,0.8863),vec3(-0.0398,0.9332,-0.3571),vec3(0.7886,0.0484,0.6129),vec3(-0.9591,-0.1973,0.2028),vec3(-0.1497,0.8013,0.5792),vec3(0.7559,-0.2656,0.5984),vec3(0.3612,-0.2407,-0.9009),vec3(-0.7039,0.5626,-0.4336),
vec3(0.9402,0.1480,0.3069),vec3(-0.4737,-0.8804,-0.0207),vec3(0.1693,-0.2775,0.9457),vec3(0.8539,-0.1546,0.4970),vec3(0.9280,0.3469,0.1357),vec3(-0.8714,0.2812,-0.4021),vec3(-0.7584,-0.4324,-0.4878),vec3(-0.2459,-0.5846,0.7731),vec3(-0.1898,-0.9760,-0.1064),vec3(-0.4554,-0.6271,0.6320),
vec3(-0.0861,-0.5893,-0.8033),vec3(-0.4877,0.4949,0.7192),vec3(-0.2857,-0.1608,-0.9447),vec3(0.4489,0.4014,0.7983),vec3(0.5612,0.2127,0.7999),vec3(0.9908,-0.1266,0.0482),vec3(-0.1412,0.6349,-0.7596),vec3(-0.6325,-0.4297,-0.6444),vec3(0.8855,-0.2146,0.4122),vec3(0.2940,0.6887,0.6627),
vec3(0.1285,0.3435,-0.9303),vec3(-0.4665,0.7186,0.5157),vec3(0.3697,-0.1658,0.9142),vec3(-0.7340,0.6021,-0.3143),vec3(-0.1397,0.9508,0.2765),vec3(0.5486,0.7749,-0.3140),vec3(-0.6575,0.4962,-0.5671),vec3(-0.5788,0.5808,0.5724),vec3(0.6080,0.6567,0.4462),vec3(-0.8232,0.3560,-0.4423),
vec3(0.8277,0.5364,0.1649),vec3(-0.7422,-0.6513,-0.1580),vec3(0.5769,0.0399,-0.8159),vec3(-0.2744,-0.1361,-0.9519),vec3(0.2470,-0.9689,-0.0177),vec3(0.0823,0.8925,-0.4435),vec3(-0.8972,0.3039,-0.3205),vec3(-0.8205,-0.3820,-0.4253),vec3(0.6975,0.2833,-0.6582),vec3(-0.9792,0.0228,-0.2015),
vec3(-0.5752,-0.7162,0.3953),vec3(0.1446,0.7924,-0.5926),vec3(0.4905,-0.8055,0.3327),vec3(0.9771,-0.1796,-0.1139),vec3(0.5641,-0.8149,-0.1334),vec3(-0.7598,-0.0287,-0.6495),vec3(-0.1425,0.7767,-0.6136),vec3(-0.0207,-0.9723,0.2328),vec3(0.0727,0.8839,-0.4620),vec3(0.9574,-0.2629,0.1194),
vec3(-0.3325,-0.3132,0.8896),vec3(-0.7299,-0.5322,0.4289),vec3(0.4363,0.8253,0.3584),vec3(0.3329,0.2123,0.9188),vec3(-0.0276,0.8343,0.5507),vec3(0.6157,-0.7580,0.2155),vec3(0.3765,-0.2354,0.8960),vec3(-0.1474,-0.4501,-0.8807),vec3(-0.1377,-0.8758,-0.4626),vec3(0.0289,0.2275,0.9734),
vec3(-0.7449,-0.3858,0.5444),vec3(0.3713,-0.9272,-0.0493),vec3(-0.7672,0.5296,0.3618),vec3(0.9835,-0.0716,-0.1661),vec3(0.8197,0.5202,-0.2397),vec3(-0.3532,0.7392,-0.5735),vec3(-0.9697,-0.0696,-0.2341),vec3(0.3150,0.1261,-0.9407),vec3(-0.1519,-0.9868,-0.0554),vec3(-0.8839,-0.3280,-0.3333),
vec3(-0.3019,-0.0563,0.9517),vec3(0.4787,-0.8710,0.1109),vec3(0.4554,-0.5594,0.6926),vec3(0.2386,-0.9535,-0.1839),vec3(-0.4122,0.9079,-0.0760),vec3(-0.7238,0.2241,0.6526),vec3(0.0026,-0.1867,0.9824),vec3(0.7702,0.6360,0.0479),vec3(0.4053,0.3342,0.8509),vec3(-0.1094,0.8715,0.4780),
vec3(-0.9790,-0.1528,0.1349),vec3(0.3427,-0.0595,0.9376),vec3(-0.1873,-0.7374,0.6490),vec3(-0.1492,0.3644,0.9192),vec3(-0.2463,0.9239,0.2927),vec3(0.5722,-0.7839,-0.2409),vec3(0.8489,-0.5265,-0.0469),vec3(-0.3633,-0.4352,0.8238),vec3(-0.0082,0.2418,-0.9703),vec3(0.6171,0.3844,-0.6866),
vec3(0.5257,-0.8488,-0.0569),vec3(-0.8584,-0.5056,0.0860),vec3(0.4489,-0.1518,-0.8806),vec3(0.8798,0.3549,0.3161),vec3(-0.5401,-0.3178,0.7793),vec3(-0.1367,0.6097,-0.7807),vec3(0.4656,-0.8762,-0.1245),vec3(0.3255,0.8372,-0.4395),vec3(-0.2256,0.0852,0.9705),vec3(-0.7652,0.6059,0.2175),
vec3(0.4028,-0.7715,-0.4925),vec3(-0.3008,-0.6080,-0.7348),vec3(0.2622,0.9608,0.0900),vec3(-0.3133,0.6870,0.6556),vec3(0.4927,0.5505,0.6740),vec3(-0.3530,-0.6564,0.6667),vec3(-0.7267,-0.3475,-0.5926),vec3(0.4811,0.8721,0.0888),vec3(0.3967,0.5294,0.7499),vec3(-0.6449,0.0977,-0.7580),
vec3(0.5877,-0.3829,0.7127),vec3(-0.5686,-0.1934,0.7996),vec3(0.8080,0.1697,-0.5643),vec3(0.5029,0.1770,-0.8460),vec3(0.3387,-0.9395,-0.0516),vec3(-0.7079,0.2233,0.6701),vec3(-0.7389,0.6711,-0.0612),vec3(0.2428,-0.9546,-0.1725),vec3(-0.6579,0.7531,0.0055),vec3(-0.6488,-0.1337,-0.7491),
vec3(-0.1617,-0.6580,-0.7354),vec3(0.4642,-0.4853,0.7410),vec3(-0.4644,0.8614,0.2059),vec3(-0.5185,-0.7147,-0.4694),vec3(0.6753,-0.1077,0.7296),vec3(0.4156,0.2150,-0.8838),vec3(-0.8512,-0.5181,-0.0845),vec3(-0.7679,0.4614,0.4444),vec3(-0.3437,0.8821,-0.3220),vec3(-0.0851,0.9766,-0.1976),
vec3(0.0550,-0.9970,0.0540),vec3(0.6148,-0.0185,0.7885),vec3(0.3224,0.7656,0.5567),vec3(0.0988,-0.4985,-0.8613),vec3(0.2995,0.8453,-0.4424),vec3(0.9693,-0.0466,-0.2413),vec3(0.2206,-0.6476,0.7293),vec3(-0.8773,0.4524,-0.1601),vec3(-0.1131,-0.8465,-0.5202),vec3(-0.9807,0.0101,0.1953),
vec3(0.3619,-0.9313,-0.0412),vec3(-0.3746,0.4736,0.7971),vec3(0.4427,0.2194,0.8694),vec3(-0.6491,-0.4176,0.6358),vec3(0.7677,-0.4859,0.4178),vec3(0.3023,0.8197,0.4864),vec3(-0.5473,0.2477,0.7994),vec3(-0.0026,-0.4939,-0.8695),vec3(0.9161,0.2302,-0.3282),vec3(0.1240,-0.0435,-0.9913),
vec3(0.0647,-0.7518,0.6562),vec3(-0.9324,-0.3612,0.0149),vec3(0.3891,0.8815,-0.2677),vec3(-0.8372,0.0108,-0.5467),vec3(-0.9913,-0.1116,0.0697),vec3(0.9065,-0.0328,-0.4210),vec3(0.3090,-0.3991,-0.8633),vec3(0.5422,-0.1305,-0.8301),vec3(-0.2179,-0.4552,-0.8633),vec3(-0.8083,0.5605,-0.1804),
vec3(0.6036,-0.2613,-0.7532),vec3(-0.9852,0.1277,-0.1140),vec3(0.0688,0.5989,0.7979),vec3(-0.7603,0.5799,-0.2927),vec3(-0.1811,-0.6246,-0.7596),vec3(-0.9241,-0.3562,0.1382),vec3(0.0275,-0.6608,0.7501),vec3(0.9527,-0.0271,-0.3029),vec3(0.3897,-0.0937,-0.9162),vec3(-0.6819,-0.1527,-0.7153),
vec3(0.5182,-0.1197,-0.8468),vec3(0.6553,0.5823,0.4811),vec3(0.9446,0.3165,-0.0869),vec3(-0.3154,0.8873,0.3365),vec3(-0.8032,-0.4428,0.3985),vec3(-0.9711,-0.1914,0.1427),vec3(0.7860,-0.5620,0.2574),vec3(-0.6340,-0.1651,0.7555),vec3(-0.8607,0.3920,0.3247),vec3(-0.6369,-0.1750,0.7508),
vec3(-0.2335,-0.9702,-0.0650),vec3(0.6929,0.0729,-0.7173),vec3(0.1585,-0.4784,-0.8637),vec3(0.5649,0.7052,0.4285),vec3(-0.9149,0.1245,-0.3840),vec3(-0.0403,0.9387,0.3423),vec3(-0.6480,0.6980,0.3048),vec3(-0.5254,-0.8486,0.0621),vec3(0.4368,0.7900,0.4302),vec3(-0.1799,0.9836,0.0096),
vec3(0.3195,0.9473,-0.0240),vec3(0.3383,0.9410,-0.0043),vec3(-0.2273,0.4336,0.8720),vec3(0.7123,-0.6660,-0.2214),vec3(-0.6326,0.1161,-0.7657),vec3(-0.7038,0.4850,-0.5192),vec3(0.3996,0.8388,0.3698),vec3(0.7206,-0.1425,0.6785),vec3(-0.2844,0.1870,0.9403),vec3(0.4598,-0.6812,-0.5697),
vec3(-0.6393,-0.5659,0.5207),vec3(-0.7041,0.6899,0.1682),vec3(0.7031,-0.6841,-0.1941),vec3(0.2172,-0.9759,0.0201),vec3(-0.9758,0.2184,-0.0087),vec3(0.3729,-0.8771,0.3027),vec3(0.7014,-0.5201,0.4874),vec3(-0.8289,0.3949,-0.3961),vec3(-0.2887,0.4929,-0.8208),vec3(-0.6227,-0.4327,0.6519),
vec3(0.7962,-0.5634,-0.2208),vec3(-0.2476,-0.7972,0.5506),vec3(-0.5509,0.5341,-0.6413),vec3(-0.0589,-0.6214,-0.7813),vec3(0.5618,-0.1667,0.8103),vec3(-0.6347,-0.1750,0.7527),vec3(-0.0279,-0.0072,0.9996),vec3(-0.2566,0.6352,0.7285),vec3(0.3398,0.1631,-0.9262),vec3(0.4128,0.9064,0.0894),
vec3(0.0814,0.0538,0.9952),vec3(-0.9736,0.2273,0.0220),vec3(0.6637,0.0390,0.7470),vec3(0.4399,-0.2601,-0.8596),vec3(-0.1385,-0.1734,0.9751),vec3(0.5341,0.0048,0.8454),vec3(0.9737,0.1882,0.1285),vec3(0.2556,0.9570,-0.1371),vec3(-0.9083,0.2641,-0.3243),vec3(0.6254,0.6434,0.4414),
vec3(0.2318,0.0126,-0.9727),vec3(-0.1389,-0.9577,-0.2519),vec3(-0.3251,0.4239,0.8454),vec3(0.1893,-0.9775,0.0930),vec3(-0.9206,0.3870,-0.0522),vec3(-0.9216,0.3882,-0.0069),vec3(0.8803,0.2812,-0.3821),vec3(0.4116,0.1327,0.9017),vec3(0.2236,0.1441,0.9640),vec3(-0.8302,-0.5569,0.0271),
vec3(0.0096,0.1713,0.9852),vec3(0.5409,-0.8364,-0.0883),vec3(0.6170,-0.7730,-0.1479),vec3(0.7978,-0.1857,-0.5736),vec3(-0.7878,0.0550,-0.6135),vec3(0.1384,0.7334,0.6655),vec3(0.1328,0.8814,0.4533),vec3(-0.9717,-0.2287,0.0595),vec3(0.0572,-0.7507,0.6582),vec3(-0.5752,0.8177,0.0237),
vec3(-0.9652,0.2399,0.1039),vec3(-0.5249,-0.6290,-0.5734),vec3(0.8546,-0.4886,0.1756),vec3(0.3690,0.5944,-0.7145),vec3(-0.0953,-0.4346,-0.8956),vec3(-0.8216,-0.4366,0.3666),vec3(-0.8917,0.3972,0.2171),vec3(0.6185,-0.5505,-0.5607),vec3(-0.7687,0.6115,-0.1874),vec3(0.4168,0.8711,0.2598),
vec3(-0.6650,-0.7386,0.1106),vec3(-0.4748,-0.4688,-0.7448),vec3(-0.3527,0.6617,-0.6616),vec3(0.0206,-0.0597,-0.9980),vec3(0.9865,-0.0032,-0.1637),vec3(0.9926,-0.1192,-0.0230),vec3(0.5116,0.5249,-0.6803),vec3(0.1050,0.9368,0.3337),vec3(0.2624,0.0393,-0.9642),vec3(-0.5068,-0.4057,-0.7606),
vec3(0.3276,0.2739,0.9043),vec3(-0.2566,0.1686,0.9517),vec3(0.2583,-0.2304,-0.9382),vec3(-0.9545,-0.2978,-0.0122),vec3(-0.4680,0.5047,0.7254),vec3(0.2219,0.8284,-0.5142),vec3(-0.6931,0.2697,0.6685),vec3(0.7496,-0.2117,0.6272),vec3(0.6873,0.6790,0.2579),vec3(-0.0929,0.0173,-0.9955),
vec3(0.6040,-0.7598,-0.2406),vec3(0.5663,0.1583,0.8088),vec3(-0.3345,-0.8706,0.3607),vec3(0.9617,-0.1277,-0.2424),vec3(-0.2002,0.9436,0.2639),vec3(0.5724,0.6393,-0.5135),vec3(-0.3915,-0.9090,0.1428),vec3(0.2257,-0.1443,0.9635),vec3(-0.5482,-0.4586,0.6994),vec3(0.7291,-0.5299,-0.4331),
vec3(0.3240,0.8729,0.3649),vec3(0.0267,-0.9585,-0.2838),vec3(-0.1292,0.1869,0.9739),vec3(-0.4838,0.2714,-0.8320),vec3(0.4837,0.7188,-0.4994),vec3(0.3287,-0.7101,0.6227),vec3(-0.3934,-0.3930,-0.8312),vec3(-0.0717,-0.9955,0.0625),vec3(0.2712,-0.7516,0.6012),vec3(0.8013,0.3601,0.4776),
vec3(0.6643,-0.2122,-0.7167),vec3(-0.9921,0.0151,-0.1242),vec3(0.0308,-0.9537,-0.2992),vec3(-0.0477,-0.9979,-0.0430),vec3(0.4804,-0.8594,0.1748),vec3(0.3912,0.5875,-0.7084),vec3(-0.5646,0.1552,0.8107),vec3(-0.7075,-0.6487,0.2804),vec3(0.6726,-0.3053,-0.6741),vec3(0.5051,-0.8530,0.1318),
vec3(0.3997,-0.3083,0.8632),vec3(-0.7159,-0.4085,0.5662),vec3(-0.8058,-0.4613,0.3714),vec3(0.6111,-0.7886,-0.0676),vec3(0.8566,0.1907,-0.4794),vec3(0.7446,-0.6530,0.1385),vec3(-0.7233,0.4736,-0.5025),vec3(0.9082,0.2113,-0.3614),vec3(-0.0138,-0.5699,0.8216),vec3(0.3589,0.5269,0.7704),
vec3(0.4996,0.6350,0.5892),vec3(-0.4122,-0.3238,0.8516),vec3(-0.0216,0.7661,-0.6423),vec3(-0.4490,0.8929,0.0351),vec3(-0.7888,0.5597,0.2540),vec3(-0.4685,0.3125,0.8264),vec3(-0.7133,0.6194,0.3279),vec3(-0.7521,-0.6206,-0.2216),vec3(0.4376,0.7603,0.4800),vec3(0.2929,0.7146,0.6353),
vec3(0.8115,0.5488,0.2007),vec3(-0.2475,0.4998,-0.8300),vec3(0.0657,-0.5312,0.8447),vec3(0.0449,0.4482,-0.8928),vec3(-0.0604,-0.9967,0.0540),vec3(-0.2276,-0.6059,-0.7623),vec3(0.4357,-0.8676,-0.2397),vec3(0.3671,-0.6883,0.6257),vec3(-0.2312,0.8274,-0.5118),vec3(-0.2330,0.5955,0.7688),
vec3(-0.8956,-0.1305,0.4253),vec3(-0.4419,0.8633,-0.2437),vec3(0.4254,-0.7529,-0.5022),vec3(0.3215,-0.8077,-0.4943),vec3(-0.7916,-0.2963,0.5345),vec3(-0.0354,0.4339,-0.9003),vec3(-0.3925,-0.8418,0.3706),vec3(0.0995,0.9655,0.2406),vec3(-0.8374,0.2352,0.4934),vec3(-0.2231,0.1978,0.9545),
vec3(-0.9442,-0.2336,-0.2322),vec3(0.8763,-0.0457,-0.4796),vec3(0.0215,-0.6554,0.7549),vec3(0.7848,-0.0969,0.6122),vec3(0.0952,0.9924,-0.0778),vec3(-0.5659,-0.1026,-0.8181),vec3(0.9404,0.3150,0.1285),vec3(0.0337,-0.7797,-0.6252),vec3(-0.8000,-0.5966,0.0634),vec3(0.5968,-0.7482,-0.2899),
vec3(0.9263,-0.0684,-0.3704),vec3(0.8052,-0.3821,0.4535),vec3(-0.8423,0.5381,0.0315),vec3(0.8137,0.0017,0.5813),vec3(-0.7802,-0.2049,-0.5910),vec3(0.2453,0.9016,0.3562),vec3(0.0855,0.4377,-0.8950),vec3(-0.3660,0.7094,0.6023),vec3(0.7694,0.5296,0.3571),vec3(-0.0070,-0.4519,0.8920),
vec3(-0.0054,-0.5768,-0.8169),vec3(-0.5556,-0.1550,0.8169),vec3(-0.5258,0.8504,0.0199),vec3(0.4813,-0.8459,0.2298),vec3(-0.8796,-0.3016,-0.3679),vec3(0.5158,-0.1410,-0.8450),vec3(0.5573,-0.4446,0.7012),vec3(-0.4363,0.5516,-0.7109),vec3(-0.9251,-0.2776,-0.2590),vec3(-0.5534,0.7961,0.2448),
vec3(-0.0708,-0.0689,0.9951),vec3(0.2886,-0.9568,0.0347),vec3(-0.0050,-0.1938,0.9810),vec3(0.5900,0.5940,-0.5469),vec3(0.4301,-0.8794,-0.2040),vec3(0.9080,0.1447,0.3931),vec3(-0.4224,0.2519,-0.8707),vec3(-0.1013,-0.8628,0.4953),vec3(0.1934,-0.9681,-0.1592),vec3(-0.5259,0.5795,0.6226));

   //grab a normal for reflecting the sample rays later on
   vec3 fres = normalize((texture2D(rnm,uv*offset).xyz*2.0) - vec3(1.0));
   //vec3 fres = normalize(texture2D(rnm,uv*offset).xyz);

 
	//取出当前点的向量值
   vec4 currentPixelSample = texture2D(normalMap,uv);
 
	//渲染第二遍，将场景本身的颜色取出。如果不做混合，则不需要
	//vec4 sampleColor = texture2D(color, uv);

	//取出当前点的深度值
   float currentPixelDepth = currentPixelSample.a;
 
   // current fragment coords in screen space
   //ep表示当前点的屏幕空间的坐标，加上深度值，组成的屏幕空间的三维坐标
   vec3 ep = vec3(uv.xy,currentPixelDepth);

   //get the normal of current fragment
   //norm表示当前点的法向量
   vec3 norm = currentPixelSample.xyz;
 
   float bl = 0.0;
   // adjust for the depth ( not shure if this is good..)

   float radD = rad/currentPixelDepth;
 
   vec3 ray, se, occNorm;
   float occluderDepth, depthDifference, normDiff;
 
   for(int i=0; i<SAMPLES;++i)
   {
      // get a vector (randomized inside of a sphere with radius 1.0) from a texture and reflect it
      
	  ray = radD*reflect(pSphere[i],fres);
 
      // if the ray is outside the hemisphere then change direction
	  //如果光线ray和法向量norm的夹角大于90，那么sign后得-1， se = ep - ray，否则，是 se = ep + ray
      se = ep + sign(dot(ray,norm) )*ray;
 
      // get the depth of the occluder fragment
	  //取得se位置的normal
      vec4 occluderFragment = texture2D(normalMap,se.xy);
 
      // get the normal of the occluder fragment
	  //得到occluder位置的normal
      occNorm = occluderFragment.xyz;
 
      // if depthDifference is negative = occluder is behind current fragment
	  //depthDifference表示当前的深度减去采样点的深度，如果是负的，表示采样点在后面
      depthDifference = currentPixelDepth-occluderFragment.a;
 
      // calculate the difference between the normals as a weight
	//这两个normal的角度越大，normdiff越大
      normDiff = (1.0-dot(occNorm,norm));
      // the falloff equation, starts at falloff and is kind of 1/x^2 falling
	  //step(edge, x): 如 x<edge 则0.0, 否则 1.0
	  //smoothstep(edge0, edge1, x): x 在两个之间的时候，平滑差值，小于edge0 = 0， 大于edge1， 1.
	  //step(falloff,depthDifference) 如果depthDIfference小于falloff，则整个式子为0
	  //smoothstep(falloff,strength,depthDifference) depthDifference越靠近strength，式子越接近1.
	   bl += step(falloff,depthDifference)*normDiff*(1.0-smoothstep(falloff,strength,depthDifference));
   }
 
   // output the result
   float ao = 1.0-totStrength*bl*invSamples;
   
   //if(ao<0) ao =0.0;
   //if(ao>1) a0 =1.0;
   
   //Blend
   //gl_FragColor = vec4(ao)*sampleColor;

   //SSAO only
   gl_FragColor = vec4(ao);

   //gl_FragColor = sampleColor;

}