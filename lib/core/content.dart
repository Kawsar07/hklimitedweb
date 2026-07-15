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
      'manufacturers around the world, and make it reliably available to '
      'installers, EPC companies and retailers across every market we '
      'serve — with authentic products, honest pricing and a sourcing '
      'network built to keep growing worldwide.';

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
    ),
    ProductCategory(
      title: 'Tier 1 Solar Panels',
      detail: 'Premium Tier 1 solar panels from world-renowned manufacturers, engineered for maximum efficiency, durability, and reliable energy production.',
      icon: 'panel',
    ),
    ProductCategory(
      title: 'Solar Mounting Structures',
      detail: 'Roof-top and ground-mount structures engineered for '
          'regional wind and load conditions.',
      icon: 'mount',
    ),
    ProductCategory(
      title: 'DC Cables & Connectors',
      detail: 'Solar-grade DC cables and MC4 connectors built for '
          'outdoor durability.',
      icon: 'cable',
    ),
    ProductCategory(
      title: 'Other Accessories',
      detail: 'Combiner boxes, circuit breakers, monitoring devices and '
          'related balance-of-system components.',
      icon: 'accessory',
    ),
    ProductCategory(
      title: 'Hybrid Controllers',
      detail: 'Hybrid solar charge controllers and power controllers built '
          'for seamless grid, battery and generator integration.',
      icon: 'controller',
    ),
    ProductCategory(
      title: 'SCADA Monitoring',
      detail: 'SCADA and remote monitoring systems for real-time plant '
          'performance, fault detection and unattended operation.',
      icon: 'scada',
    ),
  ];

  static const List<SourcingCountry> sourcingCountries = [
    SourcingCountry(
      country: 'China',
      detail: 'Cost-effective, high-volume solar panels, inverters, '
          'mounting structures and accessories.',
    ),
    SourcingCountry(
      country: 'Germany',
      detail: 'Premium-quality inverters and engineering-grade '
          'components.',
    ),
    SourcingCountry(
      country: 'Netherlands',
      detail: 'Specialised accessories and cabling solutions.',
    ),
    SourcingCountry(
      country: 'Worldwide Network',
      detail: 'New sourcing countries added continuously as reliable '
          'manufacturers are identified, extending our reach worldwide.',
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
        'hybrid controllers, SCADA monitoring and accessories.',
    'A growing network, built from day one to serve and expand into new '
        'markets worldwide.',
  ];

  static const List<StatItem> stats = [
    StatItem(value: founded, label: 'Founded'),
    StatItem(value: '3+', label: 'Sourcing countries'),
    StatItem(value: '7', label: 'Product categories'),
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
  const ProductCategory({
    required this.title,
    required this.detail,
    required this.icon,
  });
}

class SourcingCountry {
  final String country;
  final String detail;
  const SourcingCountry({required this.country, required this.detail});
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
