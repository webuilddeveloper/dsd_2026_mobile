/// ไฟล์นี้เก็บ string ทุกอย่างที่ต้องแปลภาษา
/// เพิ่ม key ใหม่ได้เลย แล้วเรียกผ่าน AppStrings.of(context).key

import 'package:flutter/material.dart';

class AppStrings {
  final String languagePageTitle;
  final String selectLanguage;
  final String languageChangeNote;
  final String languageThai;
  final String languageEnglish;

  // ── เพิ่ม string อื่นๆ ที่ต้องการแปลได้เลย ──
  final String profile;
  final String changePassword;
  final String trainingHistory;
  final String notificationSettings;
  final String aboutUs;
  // หน้า  profile
  final String titlerofile;
  final String titleaccount;
  final String useraccount;
  final String workhistory;
  final String activities;
  final String trainingapplication;
  final String interest;
  final String settings;
  final String setupnoti;
  final String changelanguage;
  final String deleteaccount;
  final String logout;
  final String confirmDeleteAccountTitle;
  final String confirmDeleteAccountDescription;
  final String cancel;
  final String confirm;
  // หน้า  menu
  final String home;
  final String calendar;
  final String notification;
  //หน้า Home
  final String logged;
  final String tologin;
  final String verified;
  final String certified;
  final String general;
  final String search;
  final String service;
  final String seeall;
  final String standtest;
  final String skillTestSchedule;
  final String trainingapp;
  final String trainingCourses;
  final String cert;
  final String knowledge;
  final String privilege;
  final String recommended;
  final String recommendedGuest;
  final String pressrelease;
  // หน้าcalendar
  final String list;
  final String activity;
  final String thedetails;
  final String dateposting;

  // edit profile
  final String personal;
  final String prefix;
  final String name;
  final String lastname;
  final String phone;
  final String phoneNumber;
  final String email;
  final String idcard;
  final String please;
  final String save;
  final String photo;
  final String camera;
  final String updateSuccess;
  final String updateFailed;

  // Work history
  final String trainingresults;
  final String skillresult;
  final String evaluationresults;
  final String cardholdernumber;
  final String dateIssue;
  final String licenseStatus;

  // changpassword
  final String skipchangePassword;
  final String skipchangePassword1;
  final String skipchangePassword2;
  final String skipchangePassword3;
  final String skipchangePassword4;
  final String skipchangePassword5;
  final String currentPassword;
  final String newPassword;
  final String confirmNewpassword;
  final String confirmpassword;
  final String strength;
  final String labelstrength1;
  final String labelstrength2;
  final String labelstrength3;
  final String password;
  final String successfully;
  final String failed;
  final String passwordsnotmatch;
  //historyTraning
  final String allcourse;
  final String totalhours;
  final String trainingList;
  final String batchNo;
  final String hours;
  final String noData;
  final String statusPendingReview;
  final String statusPendingApproval;
  final String statusPendingSelection;
  final String statusFailed;
  final String statusCancelled;
  final String statusContacted;
  final String statusNotContacted;
  final String statusUnknown;
  final String trainingDetails;
  final String organization;
  final String trainingDate;
  final String duration;
  final String viewCertificate;
  final String certificateNotAvailable;

  //settingNoti
  final String generalNoti;
  final String enablenoti;
  final String skipenablenoti;
  final String notificationsound;
  final String skipnotisound;
  final String vibration;
  final String skipvibration;
  final String typenoti;
  final String training;
  final String skiptraining;
  final String news;
  final String skipnews;
  //about us
  final String loaddata;
  final String aboutapp;
  final String privacypolicy;
  final String contactUs;
  final String address;
  final String contactinfo;
  final String onlineplatforms;
  final String navigate;
  //interest
  final String selectinterests;
  final String interestSkip;
  final String recommendations;
  final String skip;
  final String next;

  //knowledge
  final String read;
  final String author;
  final String publisher;
  final String category;
  final String bookType;
  final String numberOfPages;
  final String size;
  final String publishDate;

  //certified
  final String certifiedTitle;
  final String userManual;
  final String scanAndroid;
  final String scanIos;
  final String or;
  final String requirementTitle;
  final String requirementDescription;
  final String appStore;
  final String googlePlay;
  final String thaId;
  // forgot
  final String forgot;
  final String skipforgot;
  final String invalidemail;
  final String confirmemail;
  // regidter
  final String signUp;
  final String userInformation;
  final String user;
  final String idcardNumber;
  final String titlePrefix;
  final String dateOfBirth;
  final String pleaseEnterInformation;
  final String pleaseEnterIdCardNumber;
  final String idCardNumberMustBe13Digits;
  final String phoneNumberMustBe10Digits;
  final String registerSuccess;
  final String accountReady;
  final String registerFailed;
  // login
  final String login;
  final String noAccount;
  final String backToPreviousPage;
  final String loginFailed;

  const AppStrings({
    required this.languagePageTitle,
    required this.selectLanguage,
    required this.languageChangeNote,
    required this.languageThai,
    required this.languageEnglish,
    required this.profile,
    required this.changePassword,
    required this.trainingHistory,
    required this.notificationSettings,
    required this.aboutUs,
    // หน้า  profile
    required this.titlerofile,
    required this.titleaccount,
    required this.useraccount,
    required this.workhistory,
    required this.activities,
    required this.trainingapplication,
    required this.interest,
    required this.settings,
    required this.setupnoti,
    required this.changelanguage,
    required this.deleteaccount,
    required this.logout,
    required this.confirmDeleteAccountTitle,
    required this.confirmDeleteAccountDescription,
    required this.cancel,
    required this.confirm,
    // หน้า  menu
    required this.home,
    required this.calendar,
    required this.notification,
    //หน้า Home
    required this.logged,
    required this.tologin,
    required this.verified,
    required this.certified,
    required this.general,
    required this.search,
    required this.service,
    required this.seeall,
    required this.standtest,
    required this.skillTestSchedule,
    required this.trainingapp,
    required this.trainingCourses,
    required this.cert,
    required this.knowledge,
    required this.privilege,
    required this.recommended,
    required this.recommendedGuest,
    required this.pressrelease,

    // หน้าcalendar
    required this.list,
    required this.activity,
    required this.thedetails,
    required this.dateposting,

    // edit profile
    required this.personal,
    required this.prefix,
    required this.name,
    required this.lastname,
    required this.phone,
    required this.phoneNumber,
    required this.email,
    required this.idcard,
    required this.please,
    required this.save,
    required this.photo,
    required this.camera,
    required this.updateSuccess,
    required this.updateFailed,

    // Work history
    required this.trainingresults,
    required this.skillresult,
    required this.evaluationresults,
    required this.cardholdernumber,
    required this.dateIssue,
    required this.licenseStatus,
    // changpassword
    required this.skipchangePassword,
    required this.skipchangePassword1,
    required this.skipchangePassword2,
    required this.skipchangePassword3,
    required this.skipchangePassword4,
    required this.skipchangePassword5,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewpassword,
    required this.confirmpassword,
    required this.strength,
    required this.labelstrength1,
    required this.labelstrength2,
    required this.labelstrength3,
    required this.password,
    required this.successfully,
    required this.failed,
    required this.passwordsnotmatch,
    //historyTraning
    required this.allcourse,
    required this.totalhours,
    required this.trainingList,
    required this.batchNo,
    required this.hours,
    required this.noData,
    required this.statusPendingReview,
    required this.statusPendingApproval,
    required this.statusPendingSelection,
    required this.statusFailed,
    required this.statusCancelled,
    required this.statusContacted,
    required this.statusNotContacted,
    required this.statusUnknown,
    required this.trainingDetails,
    required this.organization,
    required this.trainingDate,
    required this.duration,
    required this.viewCertificate,
    required this.certificateNotAvailable,

    // setingNoti
    required this.generalNoti,
    required this.enablenoti,
    required this.skipenablenoti,
    required this.notificationsound,
    required this.skipnotisound,
    required this.vibration,
    required this.skipvibration,
    required this.typenoti,
    required this.training,
    required this.skiptraining,
    required this.news,
    required this.skipnews,

    //about us
    required this.loaddata,
    required this.aboutapp,
    required this.privacypolicy,
    required this.contactUs,
    required this.address,
    required this.contactinfo,
    required this.onlineplatforms,
    required this.navigate,

    //interest
    required this.selectinterests,
    required this.recommendations,
    required this.skip,
    required this.next,
    required this.interestSkip,
    //knowledge
    required this.read,
    required this.author,
    required this.publisher,
    required this.category,
    required this.bookType,
    required this.numberOfPages,
    required this.size,
    required this.publishDate,

    //certified
    required this.certifiedTitle,
    required this.userManual,
    required this.scanAndroid,
    required this.scanIos,
    required this.or,
    required this.requirementTitle,
    required this.requirementDescription,
    required this.appStore,
    required this.googlePlay,
    required this.thaId,
    //forgot
    required this.forgot,
    required this.skipforgot,
    required this.invalidemail,
    required this.confirmemail,

    //signUp
    required this.signUp,
    required this.userInformation,
    required this.user,
    required this.idcardNumber,
    required this.titlePrefix,
    required this.dateOfBirth,
    required this.pleaseEnterInformation,
    required this.pleaseEnterIdCardNumber,
    required this.idCardNumberMustBe13Digits,
    required this.phoneNumberMustBe10Digits,
    required this.registerSuccess,
    required this.accountReady,
    required this.registerFailed,
    // login
    required this.login,
    required this.noAccount,
    required this.backToPreviousPage,
    required this.loginFailed,
  });

  static const AppStrings th = AppStrings(
    languagePageTitle: 'ภาษา',
    selectLanguage: 'เลือกภาษา',
    languageChangeNote: 'การเปลี่ยนภาษาจะมีผลทันทีกับทุกหน้าในแอปพลิเคชัน',
    languageThai: 'ภาษาไทย',
    languageEnglish: 'English',
    profile: 'โปรไฟล์',
    changePassword: 'เปลี่ยนรหัสผ่าน',

    trainingHistory: 'ประวัติการอบรม',
    notificationSettings: 'ตั้งค่าการแจ้งเตือน',
    aboutUs: 'เกี่ยวกับเรา',
    // หน้า  profile
    titlerofile: "โปรไฟล์",
    titleaccount: "บัญชีของฉัน",
    useraccount: "บัญชีผู้ใช้งาน",
    workhistory: "ประวัติผลงาน",
    activities: "กิจกรรมของคุณ",
    trainingapplication: "ตรวจสอบผลการสมัครฝึกอบรม",
    interest: "ความสนใจของคุณ",
    settings: "การตั้งค่า",
    setupnoti: "ตั้งค่าการแจ้งเตือน ",
    changelanguage: "เปลี่ยนภาษา",
    deleteaccount: "ลบบัญชี",
    logout: "ออกจากระบบ",
    confirmDeleteAccountTitle: "คุณต้องการลบบัญชีหรือไม่?",
    confirmDeleteAccountDescription:
        "การลบบัญชีจะทำให้ข้อมูลของคุณหายไปทั้งหมด",
    cancel: "ยกเลิก",
    confirm: "ยืนยัน",
    // หน้า  menu
    home: "หน้าหลัก",
    calendar: "ปฏิทินกิจกรรม",
    notification: "แจ้งเตือน",
    //หน้า Home
    logged: "ท่านยังไม่ได้เข้าสู่ระบบ",
    tologin: "คลิกเพิ่อเข้าสู่ระบบ",
    verified: "ท่านยังไม่ได้ยืนยันตัวตน",
    certified: "ช่างที่ได้รับการรับรอง",
    general: "บุคคลทั่วไป",
    search: "ค้นหา",
    service: "บริการ",
    seeall: "ดูทั้งหมด",
    standtest: "สมัครสอบมาตรฐาน\nที่นั่งทางวิชาชีพ",
    skillTestSchedule: "กำหนดการทดสอบมาตรฐานฝีมือแรงงาน",
    trainingapp: "สมัครฝึกอบรม",
    trainingCourses: "หลักสูตรฝึกอบรม",
    cert: "สมัครรับรองความรู้\nความสามารถ",
    knowledge: "คลังความรู้",
    privilege: "สิทธิประโยชน์",
    recommended: "คอร์สอบรมแนะนำสำหรับคุณ",
    recommendedGuest: "คอร์สอบรมแนะนำ",
    pressrelease: "ข่าวประชาสัมพันธ์",
    // หน้าcalendar
    list: "รายการ",
    activity: "กิจกรรม",
    thedetails: "รายละเอียด มีดังนี้",
    dateposting: "วันที่ลง",
    // edit profile
    personal: "ข้อมูลส่วนตัว",
    prefix: "คำนำหน้า เช่น นาย / นาง / นางสาว",
    name: "ชื่อ",
    lastname: "นามสกุล",
    phone: "โทรศัพท์",
    phoneNumber: "เบอร์โทรศัพท์",
    email: " อีเมล",
    idcard: "เลขบัตรประชาชน\n(แก้ไขไม่ได้หลังจากบันทึก)",
    please: "กรุณากรอก",
    save: "บันทึกข้อมูล",
    photo: "อัลบั้มรูปภาพ",
    camera: "กล้องถ่ายรูป",
    updateSuccess: "ข้อมูลของคุณได้รับการอัปเดตเรียบร้อยแล้ว",
    updateFailed: "ไม่สามารถบันทึกข้อมูลได้ กรุณาลองใหม่อีกครั้ง",
    // Work history
    trainingresults: "ผลการฝึกอบรม",
    skillresult: "ผลการทดสอบมาตรฐานฝีมือแรงงาน",
    evaluationresults: "ผลการประเมิน",
    cardholdernumber: "เลขประจำตัวผู้ถือบัตร",
    dateIssue: "วันออกบัตร",
    licenseStatus: "สถานะใบอนุญาต",
    // changpassword
    skipchangePassword: "รหัสผ่านต้องมีอย่างน้อย 6 ตัว มีตัวเลขและตัวพิมพ์ใหญ่",
    skipchangePassword1: "ต้องมีตัวพิมพ์ใหญ่อย่างน้อย 1 ตัว'",
    skipchangePassword2: "ต้องมีตัวเลขอย่างน้อย 1 ตัว",
    skipchangePassword3: "รหัสผ่านของคุณได้รับการเปลี่ยนแปลงเรียบร้อยแล้ว",
    skipchangePassword4: "รหัสผ่านเดิมไม่ถูกต้อง\nกรุณาลองใหม่อีกครั้ง",
    skipchangePassword5:
        "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้\nกรุณาลองใหม่อีกครั้ง",
    currentPassword: "รหัสผ่านปัจจุบัน",
    newPassword: "รหัสผ่านใหม่",
    confirmNewpassword: "ยืนยันรหัสผ่านใหม่",
    confirmpassword: "ยืนยันรหัสผ่าน",
    strength: "ความแข็งแกร่ง",
    labelstrength1: "อ่อนแอ",
    labelstrength2: "ปานกลาง",
    labelstrength3: "แข็งแกร่ง",
    password: "รหัสผ่าน",
    successfully: "สำเร็จ",
    failed: "ไม่สำเร็จ",
    passwordsnotmatch: "รหัสผ่านไม่ตรงกัน",
    //historyTraning
    allcourse: "หลักสูตรทั้งหมด",
    totalhours: "รวมชั่วโมง",
    trainingList: "รายการอบรม",
    batchNo: "รุ่นที่",
    hours: "ชั่วโมง",
    noData: "ยังไม่มีข้อมูล",
    statusPendingReview: "รอการตรวจสอบ",
    statusPendingApproval: "รออนุมัติ",
    statusPendingSelection: "รอคัดเลือก",
    statusFailed: "ไม่ผ่าน",
    statusCancelled: "ยกเลิกรุ่น",
    statusContacted: "ติดต่อแล้ว",
    statusNotContacted: "ติดต่อไม่ได้",
    statusUnknown: "ไม่ทราบสถานะ",
    trainingDetails: "รายละเอียดการอบรม",
    organization: "หน่วยงาน",
    trainingDate: "วันที่อบรม",
    duration: "ระยะเวลา",
    viewCertificate: "ดูใบประกาศนียบัตร",
    certificateNotAvailable: "ยังไม่สามารถออกใบประกาศได้",
    // setting
    generalNoti: "การแจ้งเตือนทั่วไป",
    enablenoti: "รับการแจ้งเตือนทั้งหมด",
    skipenablenoti: "เปิด/ปิดการแจ้งเตือนทั้งหมด",
    notificationsound: "เสียงแจ้งเตือน",
    skipnotisound: "เล่นเสียงเมื่อมีการแจ้งเตือน",
    vibration: "การสั่น",
    skipvibration: "สั่นเมื่อมีการแจ้งเตือน",
    typenoti: "ประเภทการแจ้งเตือน",
    training: "การอบรม",
    skiptraining: "แจ้งเตือนหลักสูตรใหม่และกำหนดการ",
    news: "ข่าวสารและประกาศ",
    skipnews: "ข่าวสารจากหน่วยงาน",
    //about us
    loaddata: "โหลดข้อมูลไม่สำเร็จ",
    aboutapp: "เกี่ยวกับแอป",
    privacypolicy: "นโยบายความเป็นส่วนตัว",
    contactUs: "ติดต่อเรา",
    address: "ที่อยู่",
    contactinfo: "ข้อมูลการติดต่อ",
    onlineplatforms: "ช่องทางออนไลน์",
    navigate: "นำทาง",
    // interests
    selectinterests: "เลือกความสนใจของคุณ",
    recommendations: "การแนะนำที่ตรงกับความชอบ",
    skip: "ข้าม",
    next: "ถัดไป",
    interestSkip: "ข้อมูลความสนใจของคุณได้รับการบันทึกเรียบร้อยแล้ว",

    //knowledge
    read: "อ่าน",
    author: "ผู้แต่ง",
    publisher: "สำนักพิมพ์",
    category: "หมวดหมู่",
    bookType: "ประเภทหนังสือ",
    numberOfPages: "จำนวนหน้า",
    size: "ขนาด",
    publishDate: "วันที่เผยแพร่",
    //certified
    certifiedTitle: "สมัครรับรองความรู้ตามมาตรฐาน",
    userManual: "คู่มือการใช้งานสำหรับประชาชน",
    scanAndroid: "สแกนสำหรับ Android",
    scanIos: "สแกนสำหรับ iOS",
    or: "หรือ",
    requirementTitle: "ข้อกำหนดเบื้องต้นของการใช้งานระบบ",
    requirementDescription:
        "การเข้าใช้งานแพลตฟอร์มระบบ Mobile Application รับรองความรู้ความสามารถสำหรับประชาชน สามารถใช้งานผ่านโทรศัพท์มือถือเคลื่อนที่ (Smart Phone) หรือแท็บเล็ต บนระบบปฏิบัติการ iOS เวอร์ชั่น 13.0 ขึ้นไป และระบบปฏิบัติการ Android เวอร์ชั่น 8.0 ขึ้นไป โดยสามารถดาวโหลดได้จากแพลตฟอร์ม App Store และ Google Play และจำเป็นที่จะต้องมี Application ThaID เพื่อยืนยันตัวตนเข้าสู่ระบบสำหรับกลุ่มผู้ใช้งานประชาชน",
    appStore: "App Store",
    googlePlay: "Google Play",
    thaId: "ThaID",
    //forgot
    forgot: "ลืมรหัสผ่าน",
    skipforgot: "กรอกอีเมลที่คุณใช้สมัคร\nเราจะส่งลิงก์ตั้งรหัสผ่านใหม่ให้คุณ",
    invalidemail: "รูปแบบอีเมลไม่ถูกต้อง",
    confirmemail: "ยืนยันอีเมล",

    //signUp
    signUp: "สมัครสมาชิก",
    userInformation: "ข้อมูลผู้ใช้งาน",
    user: "ผู้ใช้งาน",
    idcardNumber: "เลขบัตรประชาชน",
    titlePrefix: "คำนำหน้า",
    dateOfBirth: "วันเกิด",
    pleaseEnterInformation: "กรุณากรอกข้อมูล",
    pleaseEnterIdCardNumber: "กรุณากรอกเลขบัตรประชาชน",
    idCardNumberMustBe13Digits: "เลขบัตรประชาชนต้องมี 13 หลัก",
    phoneNumberMustBe10Digits: "เบอร์โทรศัพท์ต้องมี 10 หลัก",
    registerSuccess: "สมัครสมาชิกสำเร็จ",
    accountReady: "บัญชีของคุณพร้อมใช้งานแล้ว",
    registerFailed: "ไม่สามารถสมัครสมาชิกได้ กรุณาลองใหม่อีกครั้ง",
    //login
    login: "เข้าสู่ระบบ",
    noAccount: "ยังไม่มีบัญชี ",
    backToPreviousPage: "กลับหน้าก่อนหน้า",
    loginFailed: "เข้าสู่ระบบไม่สำเร็จ",
  );

  static const AppStrings en = AppStrings(
    languagePageTitle: 'Language',
    selectLanguage: 'Select Language',
    languageChangeNote:
        'Language change takes effect immediately across the app.',
    languageThai: 'ภาษาไทย',
    languageEnglish: 'English',
    profile: 'Profile',
    changePassword: 'Change Password',
    trainingHistory: 'Training History',
    notificationSettings: 'Notification Settings',
    aboutUs: 'About Us',
    // หน้า  profile
    titlerofile: "profile",
    titleaccount: "My account",
    useraccount: "User account",
    workhistory: "Performance History",
    activities: "Your activities",
    trainingapplication: "status of training application",
    interest: "interest",
    settings: "Settings",
    setupnoti: "Set up notifications",
    changelanguage: "Change language",
    deleteaccount: "Delete account",
    logout: "Log out",
    confirmDeleteAccountTitle: "Do you want to delete your account?",
    confirmDeleteAccountDescription:
        "Deleting your account will permanently remove all your data.",
    cancel: "Cancel",
    confirm: "Confirm",

    // หน้า  menu
    home: "Home",
    calendar: "Calendar",
    notification: "Notification",
    //หน้า Home
    logged: "You are not logged in.",
    tologin: "Click to log in.",
    verified: "You have not yet verified your identity.",
    certified: "Certified technician",
    general: "General public",
    search: "Search",
    service: "service",
    seeall: "See all",
    standtest: "Apply for a professional certification exam/seat",
    skillTestSchedule: "Skill Standard Test Schedule",
    trainingapp: "Apply for training",
    trainingCourses: "Training Courses",
    cert: "Apply for certification of knowledge and skills.",
    knowledge: "Knowledge",
    privilege: "Privilege",
    recommended: "Recommended Training Courses For You",
    recommendedGuest: "Recommended Training Courses",
    pressrelease: "Press Release",
    // หน้าcalendar
    list: "List",
    activity: "Activity",
    thedetails: "The details are as follows",
    dateposting: "Date of posting",
    // edit profile
    personal: "personal information",
    prefix: "Titles such as Mr. / Mrs. / Ms.",
    name: "Name",
    lastname: "LastName",
    phone: "Phone",
    phoneNumber: "Phone Number",
    email: " Email",
    idcard: "ID card number\n(Cannot be edited after saving)",
    please: "Please enter your ",
    save: "Save",
    photo: "photo album",
    camera: "Camera",
    updateSuccess: "Your information has been updated successfully",
    updateFailed: "Unable to save data. Please try again",
    // Work history
    trainingresults: "Training results",
    skillresult: "Skill Standard Test Result",
    evaluationresults: "Evaluation results",
    cardholdernumber: "Cardholder ID Number",
    dateIssue: "Date of Issue",
    licenseStatus: "License Status",
    skipchangePassword:
        "The password must be at least 6 characters long and contain numbers and uppercase letters.",
    skipchangePassword1: "Must contain at least one uppercase letter.",
    skipchangePassword2: "Must contain at least one number.",
    skipchangePassword3: "Your password has been changed successfully.",
    skipchangePassword4: "The current password is incorrect. Please try again",
    skipchangePassword5: "Unable to connect to the server. Please try again",
    currentPassword: "Current Password",
    newPassword: "New Password",
    confirmNewpassword: "Confirm New Password",
    confirmpassword: "Confirm  Password",
    strength: "Strength",
    labelstrength1: "Weak",
    labelstrength2: "Medium",
    labelstrength3: "Strong",
    password: "Password",
    successfully: "successfully",
    failed: "Failed",
    passwordsnotmatch: "Passwords do not match.",
    //historyTraning
    allcourse: "All courses",
    totalhours: "Total hours",
    trainingList: "Training List",
    batchNo: "Batch No.",
    hours: "Hours",
    noData: "No data available",
    statusPendingReview: "Pending Review",
    statusPendingApproval: "Pending Approval",
    statusPendingSelection: "Pending Selection",
    statusFailed: "Failed",
    statusCancelled: "Cancelled",
    statusContacted: "Contacted",
    statusNotContacted: "Not Contacted",
    statusUnknown: "Unknown Status",
    trainingDetails: "Training Details",
    organization: "Organization",
    trainingDate: "Training Date",
    duration: "Duration",
    viewCertificate: "View Certificate",
    certificateNotAvailable: "Certificate is not available yet",

    // settingnoti
    generalNoti: "General Notifications",
    enablenoti: "Enable all notifications",
    skipenablenoti: "Turn all notifications on/off",
    notificationsound: "Notification Sound",
    skipnotisound: "Play sound when receiving notifications",
    vibration: "Vibration",
    skipvibration: "Vibrate on notification",
    typenoti: "Types of Notifications",
    training: "Training",
    skiptraining: "Notifications for new courses and schedules",
    news: "News & Notices",
    skipnews: "Agency News",
    //about us
    loaddata: "Failed to load data",
    aboutapp: "About App",
    privacypolicy: "Privacy Policy",
    contactUs: "Contact Us",
    address: "Address",
    contactinfo: "Contact Information",
    onlineplatforms: "Online Platforms",
    navigate: "Navigate",
    //interests
    selectinterests: "Select your interests",
    recommendations: "Personalized Recommendations",
    skip: "Skip",
    next: "Next",
    interestSkip: "Your interests have been successfully recorded.",
    //knowledge
    read: "Read",
    author: "Author",
    publisher: "Publisher",
    category: "Category",
    bookType: "Book Type",
    numberOfPages: "Pages",
    size: "Size",
    publishDate: "Publish Date",

    //certified
    certifiedTitle: "Apply for Knowledge Certification",
    userManual: "User Manual for Citizens",
    scanAndroid: "Scan for Android",
    scanIos: "Scan for iOS",
    or: "OR",
    requirementTitle: "System Requirements",
    requirementDescription:
        "To access the Knowledge Certification Mobile Application platform for citizens, users can use a smartphone or tablet running iOS version 13.0 or later, or Android version 8.0 or later. The application can be downloaded from the App Store and Google Play. The ThaID application is also required for identity verification when signing into the system.",
    appStore: "App Store",
    googlePlay: "Google Play",
    thaId: "ThaID",
    //forgot
    forgot: "Forgot",
    skipforgot:
        "Enter the email you used to signUp.\nWe will send you a link to reset your password",
    invalidemail: "Invalid email format",
    confirmemail: "Confirm Email",
    //signUp
    signUp: "Sign Up",
    userInformation: "User Information",
    user: "Username",
    idcardNumber: "ID Card Number",
    titlePrefix: "Prefix",
    dateOfBirth: "Date of Birth",
    pleaseEnterInformation: "Please enter information",
    pleaseEnterIdCardNumber: "Please enter ID card number",
    idCardNumberMustBe13Digits: "ID card number must contain 13 digits",
    phoneNumberMustBe10Digits: "Phone number must contain 10 digits",
    registerSuccess: "Registration Successful",
    accountReady: "Your account is now ready to use",
    registerFailed: "Unable to register. Please try again later ",
    //login
    login: "Login",
    noAccount: "Don't have an account ? ",
    backToPreviousPage: "Back to Previous Page",
    loginFailed: "Login failed",
  );

  /// เรียกใช้: AppStrings.of(context).profile
  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'en' ? en : th;
  }
}
