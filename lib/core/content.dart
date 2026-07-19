/// All site copy lives here, so updating a sentence never means hunting
/// through widget files.
class Company {
  Company._();

  static const String name = 'Solar PV HK Limited';
  static const String shortName = 'Solar PV HK';
  static const String tagline =
      'Global solar sourcing, delivered worldwide.';
  static const String hq = 'Hong Kong';
  static const String registeredAddress =
      "Unit 909, Prosperity Millennia Plaza, 663 King's Road, "
      'Quarry Bay, Hong Kong';
  static const String founded = '2026';
  static const String phone = '+852-61880715';
  static const String email = 'info@solarpvhk.com';
  static const String website = 'www.solarpvhk.com';
  static const String logoAsset = 'assets/images/logo-icon-only.png';

  /// Where "Send Message" on the Contact page actually delivers to.
  static const String contactRecipient = 'kawsar@scube.com.bd';

  /// Free access key from https://web3forms.com — sign up with
  /// [contactRecipient] as the receiving email, then paste the key here.
  ///
  /// This is required for the contact form to actually deliver messages.
  /// Until it is set, the form falls back to opening a pre-filled mailto:
  /// draft — which does nothing on most visitors' browsers/phones because
  /// they have no default mail app configured, so nothing appears to send.
  static const String web3FormsAccessKey = 'YOUR_WEB3FORMS_ACCESS_KEY';

  static const String heroSubhead =
      'We source renewable energy hardware directly from trusted '
      'manufacturers worldwide, and make it reliably available to '
      'installers, EPC companies and retailers in every market we serve. '
      'Authentic products, honest pricing, and a sourcing network built '
      'to keep growing across the globe.';

  static const String aboutIntro =
      'Solar PV HK Limited is a Hong Kong-based company launching in $founded '
      'with one goal: make sourcing solar and renewable energy hardware '
      'simple, anywhere in the world. Reliable, good-quality solar equipment '
      'is still hard to find in many growing markets. We close that gap by '
      'working directly with trusted manufacturers worldwide and putting '
      'their products within easy reach of customers across the globe.';

  static const String mission =
      'Make renewable energy hardware sourcing simpler and more accessible '
      'worldwide, by connecting trusted overseas manufacturers directly '
      'with installers, EPC companies and retailers who need reliable, '
      'authentic supply at a fair price.';

  static const String vision =
      'To become the most trusted global sourcing partner for solar and '
      'renewable energy hardware, and a dependable bridge between '
      'world-class manufacturers and the world\u2019s growing clean energy '
      'markets.';

  static const String philosophyEyebrow = 'What we believe';
  static const String philosophyTitle =
      'A sustainable future, powered by the sun';
  static const String philosophy =
      'We’re part of a movement that envisions a sustainable, '
      'community-driven future where humanity lives in harmony with '
      'nature. It rejects climate doomerism by promoting optimism, '
      'focusing on renewable energy, and embracing accessible technology '
      'to build a better tomorrow. That’s the future we source for — '
      'putting authentic solar hardware within everyone’s reach, '
      'worldwide.';

  static const List<String> businessModel = [
    'Source renewable energy products and accessories directly from '
        'trusted manufacturers in China, Germany, the Netherlands and other '
        'countries worldwide.',
    'Make renewable energy hardware sourcing simpler and more accessible '
        'for customers through a single, reliable point of contact.',
    'Distribute and supply worldwide, continuously expanding into new '
        'countries and regions as the network grows.',
    'Position the brand as a reliable, trusted supplier of authentic solar '
        'hardware and accessories at competitive prices.',
    'Build long-term relationships with overseas manufacturers for '
        'consistent supply, faster delivery and competitive pricing.',
  ];

  static const List<ProductCategory> products = [
    ProductCategory(
      title: 'Solar Inverters',
      detail: 'On-grid, off-grid and hybrid inverters for residential, '
          'commercial and industrial installations.',
      icon: 'inverter',
      brand: 'Huawei',
      overview:
          'We supply Huawei solar inverters — one of the world’s most '
          'trusted inverter brands. The Huawei SUN2000 range covers '
          'residential, commercial and utility-scale projects, converting '
          'the DC power from your solar panels into clean, grid-ready AC '
          'power with industry-leading efficiency. Every unit is sourced '
          'directly through verified channels, so you get authentic Huawei '
          'hardware with genuine warranty support — never grey-market or '
          'counterfeit stock.',
      features: [
        'Huawei SUN2000 series — residential, commercial and utility scale',
        'On-grid, hybrid and storage-ready models',
        'Peak efficiency up to ~98.6% for maximum energy harvest',
        'Built-in smart monitoring and arc-fault (AFCI) protection',
        'Compatible with Huawei LUNA battery storage',
        'Authentic units with genuine manufacturer warranty',
      ],
    ),
    ProductCategory(
      title: 'Tier 1 Solar Panels',
      detail: 'Premium Tier 1 solar panels from world-renowned '
          'manufacturers, engineered for maximum efficiency, durability, '
          'and reliable energy production.',
      icon: 'panel',
      overview:
          'We source Tier 1 solar panels from world-renowned manufacturers, '
          'chosen for high efficiency, long-term durability and bankable '
          'performance. Available in monocrystalline and bifacial options '
          'to suit residential rooftops through to large ground-mount '
          'plants.',
      features: [
        'Tier 1 manufacturers only',
        'Monocrystalline and bifacial options',
        'High efficiency for more energy per square metre',
        'Strong performance and product warranties',
      ],
    ),
    ProductCategory(
      title: 'Solar Mounting Structures',
      detail: 'Roof-top and ground-mount structures engineered for '
          'regional wind and load conditions.',
      icon: 'mount',
      overview:
          'Roof-top and ground-mount structures engineered for regional '
          'wind and load conditions. Corrosion-resistant materials and '
          'flexible configurations make installation faster and keep '
          'arrays secure for decades.',
      features: [
        'Roof-top and ground-mount systems',
        'Engineered for local wind and load conditions',
        'Corrosion-resistant aluminium and steel',
        'Fast, hardware-complete installation kits',
      ],
    ),
    ProductCategory(
      title: 'DC Cables & Connectors',
      detail: 'Solar-grade DC cables and MC4 connectors built for '
          'outdoor durability.',
      icon: 'cable',
      overview:
          'Solar-grade DC cables and MC4 connectors built for years of '
          'outdoor exposure — UV-resistant, weatherproof and rated for '
          'high-current PV strings.',
      features: [
        'UV-resistant, weatherproof DC cabling',
        'Genuine MC4-compatible connectors',
        'High current and voltage ratings',
        'Reliable, low-loss connections',
      ],
    ),
    ProductCategory(
      title: 'Other Accessories',
      detail: 'Combiner boxes, circuit breakers, monitoring devices and '
          'related balance-of-system components.',
      icon: 'accessory',
      overview:
          'The balance-of-system components that complete an installation — '
          'combiner boxes, circuit breakers, surge protection, monitoring '
          'devices and more, all sourced to the same quality standard as '
          'the rest of the system.',
      features: [
        'Combiner boxes and enclosures',
        'Circuit breakers and surge protection',
        'Monitoring and metering devices',
        'Full balance-of-system range',
      ],
    ),
    ProductCategory(
      title: 'Hybrid Controllers',
      detail: 'Hybrid solar charge controllers and power controllers built '
          'for seamless grid, battery and generator integration.',
      icon: 'controller',
      overview:
          'Hybrid solar charge and power controllers built for seamless '
          'integration of grid, battery and generator sources — ideal for '
          'off-grid and backup-power installations that need reliable, '
          'automatic switching.',
      features: [
        'Seamless grid, battery and generator integration',
        'MPPT charge control for maximum harvest',
        'Ideal for off-grid and backup systems',
        'Automatic, reliable source switching',
      ],
    ),
    ProductCategory(
      title: 'Monitoring Systems',
      detail: 'Remote monitoring systems for real-time plant performance, '
          'fault detection and unattended operation.',
      icon: 'monitoring',
      overview:
          'Remote monitoring systems that give you real-time visibility of '
          'plant performance, automatic fault detection and alerts, so '
          'sites can run unattended with confidence.',
      features: [
        'Real-time performance monitoring',
        'Automatic fault detection and alerts',
        'Remote, unattended operation',
        'Historical data and reporting',
      ],
    ),
  ];

  static ProductCategory? productBySlug(String slug) {
    for (final p in products) {
      if (p.slugOrIcon == slug) return p;
    }
    return null;
  }

  static const List<SourcingRegion> sourcingRegions = [
    SourcingRegion(
      region: 'Asia',
      examples: 'China · India · Bangladesh · Vietnam',
      detail: 'Our largest supply base — cost-effective, high-volume '
          'solar panels, inverters, mounting structures and accessories '
          'from proven manufacturers.',
    ),
    SourcingRegion(
      region: 'Europe',
      examples: 'Germany · Netherlands',
      detail: 'Premium, engineering-grade inverters and components, plus '
          'specialised cabling and accessories built to exacting '
          'standards.',
    ),
    SourcingRegion(
      region: 'North America',
      examples: 'USA · Canada',
      detail: 'Advanced monitoring systems, high-efficiency modules and '
          'balance-of-system components for demanding installations.',
    ),
    SourcingRegion(
      region: 'South America',
      examples: 'Brazil · Chile',
      detail: 'An emerging hub connecting fast-growing regional solar '
          'markets to reliable, authentic hardware.',
    ),
    SourcingRegion(
      region: 'Africa',
      examples: 'Egypt · South Africa',
      detail: 'Sourcing and distribution partners across one of the '
          'world’s fastest-growing renewable energy regions.',
    ),
    SourcingRegion(
      region: 'Oceania',
      examples: 'Australia',
      detail: 'Rugged, high-durability equipment suited to extreme '
          'climates and strong off-grid demand.',
    ),
  ];

  static const List<String> whyChooseUs = [
    'Authentic products at low prices — every item sourced directly from '
        'verified manufacturers, with no grey-market or counterfeit risk.',
    'Faster delivery worldwide — established logistics routes get '
        'hardware to installers, EPCs and retailers on time, wherever '
        'they are.',
    'Direct manufacturer relationships — fewer middlemen, more consistent '
        'pricing and supply.',
    'Multi-country sourcing across China, Germany, the Netherlands and a '
        'growing list of countries, so you are never dependent on a '
        'single market.',
    'A single, reliable point of contact for installers, EPC companies '
        'and retailers worldwide.',
    'A full product range built around what solar and renewable energy '
        'projects actually need: inverters, panels, structures, cabling, '
        'hybrid controllers, monitoring systems and accessories.',
    'A growing network, built from day one to serve and expand into new '
        'markets worldwide.',
  ];

  static const List<StatItem> stats = [
    StatItem(value: '25+', label: 'Sourcing countries'),
    StatItem(value: '7+', label: 'Product categories'),
    StatItem(value: 'HK \u2192 World', label: 'Global trade route'),
  ];

  static const List<NavItem> navItems = [
    NavItem(label: 'Home', path: '/home'),
    NavItem(label: 'About', path: '/about'),
    NavItem(label: 'Products', path: '/products'),
    NavItem(label: 'Why Us', path: '/why-us'),
    NavItem(label: 'Contact', path: '/contact'),
  ];
}

class ProductCategory {
  final String title;
  final String detail;
  final String icon;

  /// URL slug for the detail page (/products/<slug>). Defaults to [icon].
  final String? slug;

  /// Featured brand shown on the detail page, if any (e.g. 'Huawei').
  final String? brand;

  /// Longer description shown on the detail page.
  final String? overview;

  /// Key selling points shown as a checklist on the detail page.
  final List<String> features;

  /// Optional dedicated detail-page image; falls back to the card image.
  final String? detailImage;

  const ProductCategory({
    required this.title,
    required this.detail,
    required this.icon,
    this.slug,
    this.brand,
    this.overview,
    this.features = const [],
    this.detailImage,
  });

  String get slugOrIcon => slug ?? icon;
  String get cardImage => 'assets/images/products/product_$icon.jpg';
  String get heroImage => detailImage ?? cardImage;
}

class SourcingRegion {
  final String region;
  final String examples;
  final String detail;
  const SourcingRegion({
    required this.region,
    required this.examples,
    required this.detail,
  });
}

class StatItem {
  final String value;
  final String label;
  const StatItem({required this.value, required this.label});
}

class NavItem {
  final String label;
  final String path;
  const NavItem({required this.label, required this.path});
}
