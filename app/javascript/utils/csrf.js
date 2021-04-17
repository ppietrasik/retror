const getCSRFAttribute = name => {
  const element = document.head.querySelector(`meta[name="csrf-${name}"]`);

  return element?.getAttribute("content");
};

export const csrfToken = getCSRFAttribute("token");
