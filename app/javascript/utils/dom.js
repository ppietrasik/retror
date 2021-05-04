const getElementIndex = (element, parent) => Array.prototype.indexOf.call(parent.children, element);

export const moveElement = (element, parent, index) => {
  const currentParent = element.parentNode;
  const elementAtIndex = parent.children[index];
  const currentIndex = getElementIndex(element, currentParent);
  const sameParent = parent == currentParent;

  if(currentIndex == index && sameParent) return;

  let referenceElement = elementAtIndex;

  if(sameParent && index > currentIndex){
    referenceElement = elementAtIndex.nextSibling;
  }

  parent.insertBefore(element, referenceElement);
};

export const moveCaretToTheEnd = element => element.setSelectionRange(element.value.length, element.value.length);

export const findListElement = list_id => document.querySelector(`[data-list-id-value="${list_id}"]`);
